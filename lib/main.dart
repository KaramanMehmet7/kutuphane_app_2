import 'package:flutter/material.dart';
import 'package:kutuphane_app/kitaplik.dart';
import 'package:kutuphane_app/pages/login_page.dart';
import 'package:kutuphane_app/yazarlar.dart';
import 'package:provider/provider.dart';
import 'ResimSaglayici.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kutuphane_app/pages/register_page.dart';
import 'package:kutuphane_app/pages/profile_page.dart';
import 'package:kutuphane_app/services/supabase_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Error initializing Firebase: $e');
    // For now, we'll continue even if Firebase fails
    // In a production app, you might want to show an error screen
  }
  
  try {
    // Initialize Supabase
    await SupabaseService().initialize();
    print('Supabase initialized successfully.');
  } catch (e) {
    print('Error initializing Supabase: $e');
    // For now, we'll continue even if Supabase fails
  }
  
  // Register Syncfusion license
  SyncfusionLicense.registerLicense('');
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ResimSaglayici(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kütüphane App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown.shade700,
        colorScheme: ColorScheme.light(
          primary: Colors.brown.shade700,
          onPrimary: Colors.white,
          secondary: Colors.orange.shade400,
          onSecondary: Colors.white,
          background: const Color(0xFFF5F5F5),
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        cardColor: Colors.white,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
           bodyColor: Theme.of(context).colorScheme.onSurface,
           displayColor: Theme.of(context).colorScheme.onSurface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown.shade700,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.brown.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.brown.shade800,
            side: BorderSide(color: Colors.brown.shade800),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.brown.shade800,
             textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: GoogleFonts.roboto(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
            labelStyle: GoogleFonts.roboto(
             color: Colors.brown.shade800,
             fontWeight: FontWeight.w600,
             fontSize: 16,
           ),
            errorStyle: GoogleFonts.roboto(
             color: Colors.red.shade700,
             fontSize: 14,
           ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/kitaplik': (context) => const KitaplikPage(),
        '/yazarlar': (context) => const YazarlarPage(),
        '/register': (context) => const RegisterPage(),
        '/profil': (context) => const ProfilePage(),
      },
    );
  }
}
