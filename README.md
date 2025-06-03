# 📚 Modern Kütüphane Uygulaması

Bu proje, Flutter ile geliştirilmiş modern ve responsive bir kütüphane uygulamasıdır. Firebase ve Supabase entegrasyonları ile güçlendirilmiş, kullanıcı dostu bir arayüz sunmaktadır.

> 🧑‍💻 Bu proje **Numan Salih** ve **Mehmet Fatih** tarafından birlikte geliştirilmiştir.

## 🚀 Özellikler

- 🔐 **Güvenli Kimlik Doğrulama**
  - Firebase Authentication entegrasyonu
  - Google Sign-In desteği
  - Güvenli oturum yönetimi
  - Github Sign-In entegrasyonu
  - Mail-password entegrasyonu

- 📚 **Kitap Yönetimi**
  - Kitap listesi görüntüleme
  - PDF kitap okuma desteği
  - Kitap detayları ve açıklamaları
  - Responsive tasarım ile her cihazda optimal görüntüleme

- 👥 **Yazar Profilleri**
  - Detaylı yazar bilgileri
  - Yazar eserleri listesi
  - Biyografik bilgiler

- 📱 **Modern UI/UX**
  - Material Design 3 uyumlu arayüz
  - Özel fontlar (Google Fonts)
  - Font Awesome ikonları
  - Responsive tasarım
  - Loading animasyonları
  - Hata yakalama ve kullanıcı bildirimleri

## 🛠️ Kullanılan Teknolojiler

### Backend & Veritabanı
- **Firebase**
  - Firebase Authentication (Kullanıcı girişi ve kimlik doğrulama)
  - Cloud Firestore (Veri depolama)
  - Google Sign-In entegrasyonu
  - Github Sign-In entegrasyonu
  - Mail-password entegrasyonu

- **Supabase**
  - Alternatif veritabanı çözümü
  - Gerçek zamanlı veri senkronizasyonu

### Frontend & UI
- **Flutter SDK** (>=3.6.1)
- **Syncfusion Flutter PDF Viewer** (PDF görüntüleme)
- **Provider** (State management)
- **Google Fonts** (Özel tipografi)
- **Font Awesome** (İkonlar)

### Diğer Araçlar
- **HTTP** (API istekleri)
- **Path Provider** (Dosya sistemi işlemleri)
- **Flutter Lints** (Kod kalitesi kontrolü)

## 📱 Uygulama Yapısı

| Sayfa/Dosya | Açıklama |
|-------------|-----------|
| `login.dart` | Firebase Authentication ile güvenli giriş |
| `kitaplik.dart` | Firestore/Supabase'den kitap verilerini çeken ana kitaplık sayfası |
| `yazarlar.dart` | Yazar bilgileri ve eserleri |
| `pdf_viewer_screen.dart` | Syncfusion PDF Viewer ile kitap görüntüleme |
| `drawer.dart` | Material Design 3 uyumlu navigasyon menüsü |
## 📱 Mobil Görüntüler

![1](https://github.com/user-attachments/assets/eb79b691-c239-40b7-8f1c-387f5ab8d9bc)
![2](https://github.com/user-attachments/assets/c16bb9c1-5431-4c89-aea4-dc83fbc8d70a)
![3](https://github.com/user-attachments/assets/fe3542bd-1c95-4294-a798-ad59938d5aec)
![4](https://github.com/user-attachments/assets/15e3dd3b-3045-418d-9eea-a380c9fff47d)
![5](https://github.com/user-attachments/assets/6b3e0d62-6726-4cdf-9989-741caafd33db)


## 🔧 Kurulum

1. **Gereksinimler**
   ```bash
   Flutter SDK >=3.6.1
   Dart SDK >=3.0.0
   ```

2. **Bağımlılıkları Yükleme**
   ```bash
   flutter pub get
   ```

3. **Firebase Kurulumu**
   - Firebase Console'dan yeni proje oluşturun
   - `firebase_options.dart` dosyasını projeye ekleyin
   - Authentication ve Firestore servislerini aktifleştirin

4. **Supabase Kurulumu (Opsiyonel)**
   - Supabase projenizi oluşturun
   - `.env` dosyasına Supabase URL ve anon key ekleyin

5. **Uygulamayı Çalıştırma**
   ```bash
   flutter run -d chrome  # Web için
   flutter run            # Mobil için
   ```

## 📦 Proje Yapısı

```
lib/
├── main.dart
├── screens/
│   ├── login.dart
│   ├── kitaplik.dart
│   ├── yazarlar.dart
│   └── pdf_viewer_screen.dart
├── widgets/
│   └── drawer.dart
├── services/
│   ├── auth_service.dart
│   └── database_service.dart
└── models/
    ├── book.dart
    └── author.dart
```

## 👥 Geliştirici Katkıları

- **Mehmet Fatih**
  - Firebase entegrasyonu
  - PDF görüntüleme sistemi
  - GitHub yönetimi
  - Kitaplık ve login ekranı
  - Backend servisleri

- **Numan Salih**
  - UI/UX tasarımı
  - Yazarlar sayfası
  - Sayfa geçişleri
  - Logo ve görsel yönetimi
  - Frontend optimizasyonu

## 🔐 Güvenlik Notları

- Firebase Authentication ile güvenli kullanıcı yönetimi
- Cloud Firestore güvenlik kuralları
- Supabase RLS (Row Level Security) politikaları
- Hassas bilgilerin .env dosyasında saklanması

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.

---


> 💡 **Not**: Bu uygulama sürekli geliştirilmektedir. Yeni özellikler ve iyileştirmeler düzenli olarak eklenmektedir.
