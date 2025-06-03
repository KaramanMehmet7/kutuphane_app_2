import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kutuphane_app/base_page.dart';

class YazarlarPage extends StatefulWidget {
  const YazarlarPage({Key? key}) : super(key: key);

  @override
  _YazarlarPageState createState() => _YazarlarPageState();
}

class _YazarlarPageState extends State<YazarlarPage> {
  @override
  Widget build(BuildContext context) {
    // Tema renklerine ve text stillerine erişim
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const BasePage(
        title: 'Yazarlar',
        content: Center(child: CircularProgressIndicator()),
      );
    }

    return BasePage(
      title: 'Yazarlar',
      content: ListView(
        padding: const EdgeInsets.all(16.0), // ListView'a padding ekle
        children: [
          _buildAuthorCard(
            context, // Context parametresi eklendi
            name: 'George Orwell',
            description: 'George Orwell (1903-1950), İngiliz yazar ve gazeteci. '
                'En çok \'1984\' ve \'Hayvan Çiftliği\' adlı eserleriyle tanınır. '
                'Totaliter rejimlere karşı eleştirileriyle bilinir.',
          ),
          _buildAuthorCard(
            context, // Context parametresi eklendi
            name: 'Stefan Zweig',
            description: 'Stefan Zweig (1881-1942), Avusturyalı yazar ve biyografi ustasıdır. '
                'İnsan ruhunun derinliklerine inen öyküleriyle tanınır. '
                'En bilinen eserleri arasında \'Satranç\' ve \'Bilinmeyen Bir Kadının Mektubu\' vardır.',
          ),
          _buildAuthorCard(
            context, // Context parametresi eklendi
            name: 'Jack London',
            description: 'Jack London (1876-1916), Amerikan yazar ve gazetecidir. '
                '\'Beyaz Diş\' ve \'Vahşetin Çağrısı\' gibi doğa ve hayatta kalma temalı eserleriyle ünlüdür. '
                'Doğayla insan arasındaki mücadeleyi işler.',
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard(
    BuildContext context, { // Context parametresi eklendi
    required String name,
    required String description,
  }) {
    // Tema renklerine ve text stillerine erişim
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      // Temadaki cardTheme kullanılacak. Inline elevation, margin, shape kaldırıldı.
      // elevation: 4,
      // margin: const EdgeInsets.only(bottom: 16),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(16), // Padding korundu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: textTheme.titleLarge?.copyWith( // Temadaki uygun başlık stilini kullan
                fontWeight: FontWeight.bold,
                 color: colorScheme.primary, // Tema ana rengini kullan
              ), // Manuel stil yerine tema
              // style: const TextStyle(
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              //   color: Colors.brown,
              // ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
               style: textTheme.bodyMedium?.copyWith( // Temadaki bodyMedium stilini kullan
                  height: 1.5,
                 // color: Colors.grey.shade800, // Tema textTheme rengini kullanacak
               ), // Manuel stil yerine tema
              // style: TextStyle(
              //   fontSize: 16,
              //   color: Colors.grey.shade800,
              //   height: 1.5,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
