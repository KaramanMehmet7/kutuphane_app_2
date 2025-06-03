import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kutuphane_app/auth/firebase_auth_service.dart';
import 'package:kutuphane_app/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  // Yeni eklenen controllerlar
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _currentCityController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    // Yeni eklenen controllerların dispose edilmesi
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _currentCityController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final UserCredential? userCredential = await _authService.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (userCredential?.user != null) {
        // Update the user's display name after successful registration
        await userCredential!.user!.updateDisplayName(_nameController.text.trim());
        
        // Supabase'e ek profil bilgilerini kaydet
        await _authService.supabase.createOrUpdateUserProfile(
          userId: userCredential.user!.uid,
          birthDate: DateTime.tryParse(_birthDateController.text.trim()), // Tarihi parse etmeyi dene
          birthPlace: _birthPlaceController.text.trim(),
          currentCity: _currentCityController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/kitaplik');
      } else {
        setState(() {
          _errorMessage = 'Kayıt işlemi başarısız oldu.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Kayıt Ol'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.library_books,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Kütüphane Kayıt',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 24),

            // Yeni eklenen alanlar
            TextField(
              controller: _birthDateController,
              decoration: const InputDecoration(labelText: 'Doğum Tarihi (GG.AA.YYYY)'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _birthPlaceController,
              decoration: const InputDecoration(labelText: 'Doğum Yeri'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _currentCityController,
              decoration: const InputDecoration(labelText: 'Yaşadığı Şehir'),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Kayıt Ol'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zaten hesabın var mı? Giriş Yap'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 