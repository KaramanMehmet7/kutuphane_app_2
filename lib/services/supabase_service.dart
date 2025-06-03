import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient? _supabaseClient;

  Future<void> initialize() async {
    print('SupabaseService initialize başlatılıyor...');
    // TODO: Replace with your Supabase URL and anonymous key
    const String supabaseUrl = 'https://qjrnmzqirglbiuklggli.supabase.co'; // Supabase URL'nizi buraya ekleyin
    const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFqcm5tenFpcmdsYml1a2xnZ2xpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1MzQ4NzksImV4cCI6MjA2NDExMDg3OX0.ytcZblZaw0hRp56SE35LQuLo2UCxBLa3SBy17vVxeCc'; // Supabase Anon Key'nizi buraya ekleyin

    if (supabaseUrl == 'YOUR_SUPABASE_URL' || supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY') {
        print('UYARI: Supabase URL veya Anon Key ayarlanmadı. lib/services/supabase_service.dart dosyasını güncelleyin.');
        // Uygulamanın çökmesini önlemek için burada durabilir veya bir hata fırlatabilirsiniz.
        // Şimdilik sadece uyarı veriyoruz.
        return;
    }

    try {
      print('Supabase.initialize çağrılıyor...');
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _supabaseClient = Supabase.instance.client;
      print('Supabase başlatıldı ve client ayarlandı.');
    } catch (e) {
      print('Supabase başlatılırken HATA oluştu: $e');
      // Başlatma hatasında client null kalacak.
      // Hatanın uygulamanın geri kalanını etkilememesi için burada rethrow yapmıyoruz, sadece logluyoruz.
    }
  }

  SupabaseClient get client {
    if (_supabaseClient == null) {
      print('HATA: Supabase client getter çağrıldı ama _supabaseClient null.');
      throw Exception('Supabase client başlatılmadı. SupabaseService().initialize() çağrıldığından emin olun.');
    }
    return _supabaseClient!;
  }

  // Supabase'de kullanıcı profili oluştur veya güncelle
  Future<void> createOrUpdateUserProfile({
    required String userId, // Firebase UID
    DateTime? birthDate,
    String? birthPlace,
    String? currentCity,
  }) async {
    try {
      final data = {
        'user_id': userId, // Firebase UID'sini sakla
        'birth_date': birthDate?.toIso8601String(), // Tarihi ISO 8601 formatında sakla
        'birth_place': birthPlace,
        'current_city': currentCity,
      };

      // user_id (Firebase UID) alanına göre mevcut profili bul
      final List<Map<String, dynamic>> existingProfile = await client
          .from('user_profiles')
          .select('id')
          .eq('user_id', userId)
          .limit(1);

      if (existingProfile.isNotEmpty) {
        // Profil varsa güncelle
        print('Supabase: Mevcut kullanıcı profili güncelleniyor...');
        // Güncelleme data map'inden created_at çıkarıldı
        final updateData = Map<String, dynamic>.from(data);
        updateData.remove('created_at');
        await client
            .from('user_profiles')
            .update(updateData)
            .eq('user_id', userId);
        print('Supabase: Kullanıcı profili başarıyla güncellendi.');
      } else {
        // Profil yoksa oluştur
        print('Supabase: Yeni kullanıcı profili oluşturuluyor...');
        // Oluşturma data map'ine created_at eklendi
        final insertData = Map<String, dynamic>.from(data);
        insertData['created_at'] = DateTime.now().toIso8601String();
        // id alanı otomatik olarak gen_random_uuid() ile oluşacak
        await client
            .from('user_profiles')
            .insert([insertData]);
         print('Supabase: Yeni kullanıcı profili başarıyla oluşturuldu.');
      }

    } catch (e) {
      print('Supabase kullanıcı profili işlemi sırasında hata: $e');
      rethrow;
    }
  }

  // Supabase'den kullanıcı profilini getir
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final List<Map<String, dynamic>> response = await client
          .from('user_profiles')
          .select('*')
          .eq('user_id', userId)
          .limit(1);

      if (response.isNotEmpty) {
        print('Supabase: Kullanıcı profili başarıyla getirildi.');
        return response.first;
      } else {
         print('Supabase: Kullanıcı profili bulunamadı.');
         return null; // Profil bulunamadı
      }

    } catch (e) {
      print('Supabase kullanıcı profili getirme hatası: $e');
      rethrow;
    }
  }


   // Okuma geçmişi ekle
  Future<void> addReadingHistory({
    required String userId,
    required String bookTitle,
    required String bookPdfUrl,
    required DateTime readAt,
  }) async {
    try {
       final data = {
        'user_id': userId,
        'book_title': bookTitle,
        'book_pdf_url': bookPdfUrl,
        'read_at': readAt.toIso8601String(),
      };

      await client
          .from('reading_history')
          .insert([data]);
      print('Supabase: Okuma geçmişi başarıyla eklendi.');
    } catch (e) {
      print('Supabase okuma geçmişi ekleme hatası: $e');
      rethrow;
    }
  }

  // Okuma geçmişini getir
  Future<List<Map<String, dynamic>>> getReadingHistory(String userId) async {
     try {
      final List<Map<String, dynamic>> response = await client
          .from('reading_history')
          .select('*')
          .eq('user_id', userId)
           .order('read_at', ascending: false); // En son okunanlar üstte

       print('Supabase: Okuma geçmişi başarıyla getirildi.');
      return response;
    } catch (e) {
      print('Supabase okuma geçmişi getirme hatası: $e');
      return [];
    }
  }

  // Kullanıcının eklediği kitabı Supabase'e kaydet
  Future<void> addUserBook({
    required String userId,
    required String title,
    String? author,
    String? isbn,
    String? coverImageUrl,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'title': title,
        'author': author,
        'isbn': isbn,
        'cover_image_url': coverImageUrl,
      };

      await client
          .from('user_books')
          .insert([data]);

      print('Supabase: Kullanıcı kitabı başarıyla eklendi.');
    } catch (e) {
      print('Supabase kullanıcı kitabı ekleme hatası: $e');
      rethrow;
    }
  }

  // Bir kullanıcının eklediği tüm kitapları getir
  Future<List<Map<String, dynamic>>> getUserBooks(String userId) async {
    try {
      final response = await client
          .from('user_books')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('Supabase: Kullanıcı kitapları başarıyla getirildi.');
      return response;
    } catch (e) {
      print('Supabase kullanıcı kitapları getirme hatası: $e');
      return [];
    }
  }
} 