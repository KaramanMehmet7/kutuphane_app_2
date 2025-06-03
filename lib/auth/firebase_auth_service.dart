import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign In için gerekli
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ekle
import 'package:kutuphane_app/services/supabase_service.dart';
// Google ve Github için gerekli paketleri eklemeyi unutma

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final SupabaseService supabase = SupabaseService(); // Public tanım

  // Firestore ve Supabase'e kullanıcı dokümanı oluştur/güncelle
  Future<void> _createOrUpdateUserDocument(User user) async {
    print('_createOrUpdateUserDocument çağrıldı for user: ${user.uid}');
    try {
      // Firestore işlemleri
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDocRef.get();

      final userData = {
        'userId': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'lastSignInTime': FieldValue.serverTimestamp(),
        'providerId': user.providerData.isNotEmpty ? user.providerData[0].providerId : 'unknown',
      };

      if (!docSnapshot.exists) {
        print('Firestore: Yeni kullanıcı dokümanı oluşturuluyor...');
        await userDocRef.set({
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
          'birthDate': null,
          'birthPlace': '',
          'currentCity': '',
        });
        print('Firestore: Yeni kullanıcı dokümanı başarıyla oluşturuldu');
      } else {
        print('Firestore: Mevcut kullanıcı dokümanı güncelleniyor...');
        await userDocRef.update(userData);
        print('Firestore: Kullanıcı dokümanı başarıyla güncellendi');
      }

      // Supabase işlemleri
      // print('SupabaseService createOrUpdateUserProfile çağrılıyor...'); // Yorum satırı yapıldı
      // await _supabase.createOrUpdateUserProfile(
      //   userId: user.uid,
      //   email: user.email ?? '',
      //   displayName: user.displayName,
      //   photoUrl: user.photoURL,
      //   birthDate: null, // Bu bilgiler daha sonra profil sayfasından güncellenebilir
      //   birthPlace: '',
      //   currentCity: '',
      // );
      //  print('SupabaseService createOrUpdateUserProfile tamamlandı.'); // Yorum satırı yapıldı

    } catch (e) {
      print('_createOrUpdateUserDocument sırasında HATA: $e');
      rethrow; // Hatanın yukarıya propagate olmasını sağla
    }
  }

  // E-posta ile kayıt
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        print('RegisterWithEmail başarılı, _createOrUpdateUserDocument çağrılıyor...');
        await _createOrUpdateUserDocument(userCredential.user!);
      }
      return userCredential;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // E-posta ile giriş
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
       if (userCredential.user != null) {
        print('SignInWithEmail başarılı, _createOrUpdateUserDocument çağrılıyor...');
        await _createOrUpdateUserDocument(userCredential.user!);
      }
      return userCredential;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Google ile giriş
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Google Sign-In başlatılıyor...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        print('Google Sign-In iptal edildi veya başarısız oldu');
        return null;
      }

      print('Google kullanıcısı alındı: ${googleUser.email}');
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      print('Google kimlik doğrulama başarılı');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      print('Firebase Auth ile giriş yapılıyor...');
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        print('SignInWithGoogle başarılı, _createOrUpdateUserDocument çağrılıyor...');
        await _createOrUpdateUserDocument(userCredential.user!);
        print('Google Sign-In işlemi tamamlandı');
      } else {
        print('Firebase Auth girişi başarılı ancak kullanıcı null');
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Google Sign-In Firebase hatası: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Google Sign-In genel hata: $e');
      return null;
    }
  }

  // Github ile giriş
  Future<UserCredential?> signInWithGithub() async {
     try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
       
      UserCredential userCredential = await _auth.signInWithPopup(githubProvider);
       if (userCredential.user != null) {
        print('SignInWithGithub başarılı, _createOrUpdateUserDocument çağrılıyor...');
        await _createOrUpdateUserDocument(userCredential.user!);
      }
      return userCredential;

    } on FirebaseAuthException catch (e) {
       print('GitHub Sign In error: ${e.code}');
       if (e.code == 'account-exists-with-different-credential') {
          // Hata mesajı login.dart tarafında ele alınıyor.
       } else {
           print('GitHub ile giriş sırasında hata oluştu: ${e.message}');
       }
      return null;
    } catch (e) {
      print('GitHub Sign In error: $e');
      return null;
    }
  }

  // Çıkış
  Future<void> signOut() async {
    await _auth.signOut();
     if (GoogleSignIn().currentUser != null) {
       await GoogleSignIn().signOut();
     }
  }

  // Şu anki kullanıcı
  User? get currentUser => _auth.currentUser;

  // Kullanıcı profilini güncelle (hem Firestore hem Supabase)
  Future<void> updateUserProfile({
    required String userId,
    DateTime? birthDate,
    String? birthPlace,
    String? currentCity,
  }) async {
    try {
      // Firestore güncelleme
      await _firestore.collection('users').doc(userId).update({
        'birthDate': birthDate,
        'birthPlace': birthPlace ?? '',
        'currentCity': currentCity ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Supabase güncelleme
      final user = _auth.currentUser;
      if (user != null) {
        await supabase.createOrUpdateUserProfile(
          userId: userId,
          birthDate: birthDate,
          birthPlace: birthPlace,
          currentCity: currentCity,
        );
      }

      print('Kullanıcı profili başarıyla güncellendi');
    } catch (e) {
      print('Profil güncelleme hatası: $e');
      rethrow;
    }
  }

  // Okuma geçmişi ekle
  Future<void> addReadingHistory({
    required String bookTitle,
    required String bookPdfUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('addReadingHistory: user ${user.uid} için kayıt ekleniyor...');
        await supabase.addReadingHistory(
          userId: user.uid,
          bookTitle: bookTitle,
          bookPdfUrl: bookPdfUrl,
          readAt: DateTime.now(),
        );
        print('Okuma geçmişi başarıyla eklendi');
      } else {
         print('addReadingHistory: Kullanıcı oturum açmamış, kayıt eklenemedi.');
      }
    } catch (e) {
      print('Okuma geçmişi ekleme hatası: $e');
      rethrow;
    }
  }

  // Okuma geçmişini getir
  Future<List<Map<String, dynamic>>> getReadingHistory() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('getReadingHistory: user ${user.uid} için geçmiş getiriliyor...');
        return await supabase.getReadingHistory(user.uid);
      } else {
         print('getReadingHistory: Kullanıcı oturum açmamış, geçmiş getirilemedi.');
      }
      return [];
    } catch (e) {
      print('Okuma geçmişi getirme hatası: $e');
      return [];
    }
  }
} 