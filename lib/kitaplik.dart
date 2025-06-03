import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kutuphane_app/base_page.dart';
import 'package:kutuphane_app/auth/firebase_auth_service.dart';
// import 'package:kutuphane_app/services/supabase_service.dart'; // SupabaseService artık kullanılmıyor
import 'pdf_viewer_screen.dart';

class KitaplikPage extends StatefulWidget {
  const KitaplikPage({Key? key}) : super(key: key);

  @override
  _KitaplikPageState createState() => _KitaplikPageState();
}

class _KitaplikPageState extends State<KitaplikPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  // final SupabaseService _supabaseService = SupabaseService(); // SupabaseService artık kullanılmıyor
  
  final List<Map<String, String>> pdfList = [
    {
      'title': '1984',
      'image': 'assets/images/0000000064038-1.jpg',
      'pdf': 'https://qjrnmzqirglbiuklggli.supabase.co/storage/v1/object/public/pdfs/1984.pdf',
    },
    {
      'title': 'Hayvan Çiftliği',
      'image': 'assets/images/download.jpeg',
      'pdf': 'https://qjrnmzqirglbiuklggli.supabase.co/storage/v1/object/public/pdfs/hayvan-ciftligi.pdf',
    },
    {
      'title': 'Satranç',
      'image': 'assets/images/Stefan-Zweig-SatranC3A7.jpg',
      'pdf': 'https://qjrnmzqirglbiuklggli.supabase.co/storage/v1/object/public/pdfs/satranc.pdf',
    },
    {
      'title': 'Olağanüstü bir gece',
      'image': 'assets/images/download (2).jpeg',
      'pdf': 'https://qjrnmzqirglbiuklggli.supabase.co/storage/v1/object/public/pdfs/olaganustu-bir-gece.pdf',
    },
    // Diğer kitaplar...
  ];

  // Kullanıcının eklediği kitaplarla ilgili kısımlar kaldırılıyor
  // List<Map<String, dynamic>> _userBooks = []; 
  // bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    // _loadUserBooks(); // Artık kullanıcı kitaplarını yüklemeye gerek yok
  }

  // Kullanıcının eklediği kitapları yükleme metodu kaldırılıyor
  // Future<void> _loadUserBooks() async { 
  //   setState(() { 
  //     _isLoading = true; 
  //   }); 
  //   final user = FirebaseAuth.instance.currentUser; 
  //   if (user != null) { 
  //     try { 
  //       final books = await _supabaseService.getUserBooks(user.uid); 
  //       setState(() { 
  //         _userBooks = books; 
  //       }); 
  //     } catch (e) { 
  //       print('Kullanıcı kitapları getirilirken hata: $e'); 
  //     } 
  //   } 
  //   setState(() { 
  //     _isLoading = false; 
  //   }); 
  // }

  Future<void> _openPdf(BuildContext context, Map<String, String> book) async {
    // PDF'i aç
    if (!mounted) return;

    try {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfPath: book['pdf']!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF açılırken bir hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Kitabı kullanıcının koleksiyonuna ekleme metodu kaldırılıyor
  // Future<void> _addBookToUserCollection(Map<String, String> book) async { 
  //   final user = FirebaseAuth.instance.currentUser; 
  //   if (user != null) { 
  //     try { 
  //       await _supabaseService.addUserBook( 
  //         userId: user.uid, 
  //         title: book['title']!, 
  //         author: 'Bilinmiyor', 
  //         coverImageUrl: book['image'], 
  //       ); 
  //       _loadUserBooks(); 
  //       if (!mounted) return; 
  //        ScaffoldMessenger.of(context).showSnackBar( 
  //         const SnackBar( 
  //           content: Text('Kitap koleksiyonunuza eklendi!'), 
  //           backgroundColor: Colors.green, 
  //         ), 
  //       ); 
  // 
  //     } catch (e) { 
  //       print('Kitap koleksiyonuna eklenirken hata: $e'); 
  //       if (!mounted) return; 
  //        ScaffoldMessenger.of(context).showSnackBar( 
  //         SnackBar( 
  //           content: Text('Kitap eklenirken bir hata oluştu: $e'), 
  //           backgroundColor: Colors.red, 
  //         ), 
  //       ); 
  //     } 
  //   } else { 
  //      if (!mounted) return; 
  //       ScaffoldMessenger.of(context).showSnackBar( 
  //         const SnackBar( 
  //           content: Text('Kitap eklemek için giriş yapmalısınız.'), 
  //           backgroundColor: Colors.orange, 
  //         ), 
  //       ); 
  //   } 
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Kullanıcı oturum açmamışsa login sayfasına yönlendir ve tüm önceki rotaları temizle
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/', // Login sayfası rotası
          (Route<dynamic> route) => false, // Tüm rotaları temizle
        );
      });
      return const BasePage(
        title: 'Kitaplık',
        content: Center(child: CircularProgressIndicator()),
      );
    }

    // Kullanıcının eklediği kitaplar bölümü kaldırılıyor. Sadece statik liste gösterilecek.
    return BasePage(
      title: 'Kitaplık',
      content: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: pdfList.length,
        itemBuilder: (context, index) {
          final book = pdfList[index];
          return _buildBookCard(context, book);
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Map<String, String> book) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _openPdf(context, book),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kitap Kapağı
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                  image: DecorationImage(
                    image: NetworkImage(book['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Kitap Efekti - Sağ Kenar
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    // Kitap Efekti - Alt Kenar
                    Positioned(
                      left: 0,
                      right: 8,
                      bottom: 0,
                      height: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Kitap Bilgileri
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book['title']!,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Yazar bilgisi şimdilik sabit 'Bilinmiyor', veri gelince güncellenir.
                        // Text(
                        //   'Bilinmiyor', // TODO: Yazar bilgisi veri kaynağından çekilmeli
                        //   style: textTheme.bodyMedium?.copyWith(
                        //     color: colorScheme.onSurfaceVariant,
                        //   ),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
