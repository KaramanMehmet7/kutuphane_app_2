# 📚 Kütüphane Uygulaması

Bu proje, Flutter ile geliştirilen basit bir kütüphane uygulamasıdır. Kullanıcılar giriş yaparak kitapları görüntüleyebilir, yazarlar hakkında bilgi alabilir ve PDF kitaplara erişebilir. Uygulama responsive çalışmakta olup, özellikle web üzerinde PDF görüntüleme özelliği entegre edilmiştir.

> 🧑‍💻 Bu proje **Numan** ve **Mehmet** tarafından birlikte geliştirilmiştir.

---

## 🧙️ Projedeki Sayfalar ve Görevleri

| Sayfa        | Görev                                                                 |
|--------------|-----------------------------------------------------------------------|
| `login.dart` | Kullanıcının giriş yapmasını sağlar. Basit kullanıcı adı ve şifre girişi mevcuttur. |
| `kitaplik.dart` | Kitapların kapak resimleri ve isimlerini listeler. Her kitap bir PDF ile bağlantılıdır. |
| `yazarlar.dart` | George Orwell, Stefan Zweig ve Jack London hakkında bilgi verir. |
| `pdf_viewer_screen.dart` | Seçilen kitabın PDF'ini açar. Web'de çalışacak şekilde `SfPdfViewer.network` kullanılmıştır. |
| `drawer.dart` | Uygulama genelinde kullanılan menü yapısı. Sayfalar arası geçiş sağlar. |

---

## 🖼 Drawer Menüsünde Kullanılan Logo

Drawer menüsünde üst kısımda gösterilen logo bir API üzerinden rastgele alınmamaktadır. Sabit bir görsel bağlantısı kullanılmıştır:

```
https://static.vecteezy.com/system/resources/previews/020/402/234/non_2x/library-book-reading-abstract-icon-or-emblem-vector.jpg
```

Başlangıçta Provider ile rastgele görsel kullanımı yapılmış, ancak daha sonra kullanıcı tarafından sabit bir logo tercih edilmiştir.

---

## 🔐 Login Bilgilerinin Saklanması

Uygulamada herhangi bir veritabanı veya kimlik doğrulama sistemi kullanılmamaktadır.  
**Login ekranı, kullanıcı adı ve şifreyi kontrol etmeden direkt yönlendirme yapmaktadır.**  
Bu sayede odak, uygulamanın tasarımı ve sayfa geçişlerinde olmuştur.

---

## 🧱 Grup Üyelerinin Katkısı

- **Mehmet** → Proje yapısı, PDF gösterimi, GitHub entegrasyonu, kitaplık ve login ekranı
- **Numan** → Yazarlar sayfası, tasarım detayları, sayfa geçişleri ve logo yönetimi

---

## 📜 Diğer Anlatmak İstediklerimiz

- PDF gösterimi için Syncfusion PDF Viewer kullanılmıştır.
- Web desteği olduğu için projede `flutter_pdfview` yerine `SfPdfViewer` tercih edilmiştir.
- Kullanıcı deneyimini geliştirmek için loading animasyonları, hata yakalama ve sade tema kullanılmıştır.

---

## 🥮 Çalıştırmak İçin

```bash
flutter pub get
flutter run -d chrome
```

ojede 
