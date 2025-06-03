import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kutuphane_app/base_page.dart';
import 'package:kutuphane_app/services/supabase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _currentUser = _auth.currentUser;

      if (_currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();

        if (userDoc.exists) {
          _userData = userDoc.data() as Map<String, dynamic>?;
        } else {
           _errorMessage = 'Firestore\'da kullanıcı bilgisi bulunamadı.';
           print('Firestore: Kullanıcı dokümanı ${ _currentUser!.uid} bulunamadı.');
           _userData = {};
        }

        final supabaseProfile = await SupabaseService().getUserProfile(_currentUser!.uid);
        
        if (supabaseProfile != null) {
          _userData!.addAll(supabaseProfile);
           print('Supabase: Kullanıcı profili başarıyla çekildi ve birleştirildi.');
        } else {
           print('Supabase: Kullanıcı profili bulunamadı veya çekilemedi.');
        }

      } else {
         _errorMessage = 'Kullanıcı giriş yapmamış.';
         print('Profil sayfası: Kullanıcı oturum açmamış.');
         _userData = {};
      }
    } catch (e) {
      _errorMessage = 'Profil bilgileri çekilirken hata olustu: ${e.toString()}';
      print('Profil bilgileri çekme hatası: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final iconTheme = theme.iconTheme;

    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (_currentUser == null) {
      content = Center(child: Text('Giriş yapılmadı.', style: textTheme.bodyMedium));
    } else {
      DateTime? birthDate;
      final birthDateValue = _userData?['birthDate'];

      if (birthDateValue != null) {
        if (birthDateValue is Timestamp) {
          birthDate = birthDateValue.toDate();
        } else if (birthDateValue is String && birthDateValue.isNotEmpty) {
          try {
            birthDate = DateTime.parse(birthDateValue);
          } catch (e) {
            print('Doğum tarihi string formatı parse edilemedi: $e');
            // Supabase ISO 8601 formatı deneniyor
            try {
               birthDate = DateTime.parse(birthDateValue).toLocal(); // ISO 8601 parse ve lokale çevirme
            } catch(e2) {
                print('Supabase ISO 8601 formatı parse edilemedi: $e2');
            }
          }
        }
      }

      String? photoURL = _currentUser!.photoURL ?? _userData?['photoURL']; // photoURL hem Firebase hem Supabase'den gelebilir

      content = SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profil Resmi
                CircleAvatar(
                  radius: 80,
                  backgroundColor: colorScheme.surfaceVariant,
                  backgroundImage: photoURL != null && photoURL.isNotEmpty
                      ? NetworkImage(photoURL) as ImageProvider
                      : null,
                  child: photoURL == null || photoURL.isEmpty
                      ? Icon(
                          Icons.account_circle,
                          size: 100,
                          color: colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                const SizedBox(height: 32),

                // Profil Bilgileri Kartı
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        if (_currentUser!.displayName != null && _currentUser!.displayName!.isNotEmpty)
                          _buildProfileInfoRow(
                            context: context,
                            icon: Icons.person,
                            title: 'Adı Soyadı',
                            value: _currentUser!.displayName!,
                          ),
                        const SizedBox(height: 24),

                        _buildProfileInfoRow(
                          context: context,
                          icon: Icons.email,
                          title: 'E-posta',
                          value: _currentUser!.email ?? 'N/A',
                        ),
                        const SizedBox(height: 24),

                        _buildProfileInfoRow(
                          context: context,
                          icon: Icons.calendar_today,
                          title: 'Doğum Tarihi',
                          value: birthDate != null ? '${birthDate.toLocal()}'.split(' ')[0] : 'N/A',
                        ),
                        const SizedBox(height: 24),

                        _buildProfileInfoRow(
                          context: context,
                          icon: Icons.location_city,
                          title: 'Doğum Yeri',
                          value: _userData?['birth_place'] ?? 'N/A', // Supabase kolon adı: birth_place
                        ),
                        const SizedBox(height: 24),

                        _buildProfileInfoRow(
                          context: context,
                          icon: Icons.location_on,
                          title: 'Yaşadığı İl',
                          value: _userData?['current_city'] ?? 'N/A', // Supabase kolon adı: current_city
                        ),
                        const SizedBox(height: 24),

                        if (_currentUser!.metadata.creationTime != null)
                          _buildProfileInfoRow(
                            context: context,
                            icon: Icons.timelapse,
                            title: 'Kayıt Tarihi',
                            value: '${_currentUser!.metadata.creationTime!.toLocal()}'.split(' ')[0],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BasePage(
      title: 'Profilim',
      content: content,
    );
  }

  Widget _buildProfileInfoRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final iconTheme = theme.iconTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
} 