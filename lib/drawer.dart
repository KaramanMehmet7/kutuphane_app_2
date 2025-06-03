import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              image: DecorationImage(
                image: NetworkImage(
                  'https://static.vecteezy.com/system/resources/previews/020/402/234/non_2x/library-book-reading-abstract-icon-or-emblem-vector.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  colorScheme.primary.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Kütüphane',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hoş Geldiniz',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'Ana Sayfa',
            icon: Icons.home,
            route: '/kitaplik',
          ),
          _buildDrawerItem(
            context,
            title: 'Kitaplık',
            icon: Icons.library_books,
            route: '/kitaplik',
          ),
          _buildDrawerItem(
            context,
            title: 'Yazarlar',
            icon: Icons.person,
            route: '/yazarlar',
          ),
          Divider(height: 1, thickness: 1, color: theme.dividerColor),
          _buildDrawerItem(
            context,
            title: 'Profil',
            icon: Icons.account_circle,
            route: '/profil',
          ),
          Divider(height: 1, thickness: 1, color: theme.dividerColor),
          _buildDrawerItem(
            context,
            title: 'Çıkış Yap',
            icon: Icons.logout,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? route,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isSelected = route != null && 
        ModalRoute.of(context)?.settings.name == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isSelected ? colorScheme.primary : theme.textTheme.titleMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withOpacity(0.1),
      onTap: onTap ?? () {
        if (route != null) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
