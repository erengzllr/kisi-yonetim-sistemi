# Mobil uygulama test rehberi

Bu kılavuz APK yerine kaynak koddan çalıştırma ve temel işlevleri elle doğrulama adımlarını içerir.

## Ön koşullar

- Flutter ve Dart 3 kurulu olmalı.
- Android Studio ve Android SDK kurulu olmalı; emülatör veya USB hata ayıklaması açık Android cihaz hazır olmalı.
- Backend bağımlılıkları kurulmuş ve API çalışıyor olmalı.

Android araçlarını kurduktan sonra `flutter doctor --android-licenses` ile lisansları kabul edin ve `flutter doctor` çıktısında Android toolchain'in hazır olduğunu doğrulayın.

## Başlatma

1. Bir terminalde backend'i başlatın:

   ```powershell
   cd backend_api
   .\.venv\Scripts\Activate.ps1
   python manage.py runserver 0.0.0.0:8000
   ```

2. Android emülatöründe ikinci terminalde:

   ```powershell
   cd mobile_app
   flutter pub get
   flutter run --dart-define="API_BASE_URL=http://10.0.2.2:8000/api"
   ```

3. Fiziksel cihazda `10.0.2.2` yerine bilgisayarın yerel IPv4 adresini yazın. Backend açık kalmalı ve telefon ile bilgisayar aynı ağa bağlı olmalı.

## Kabul kontrol listesi

- Liste açılır; ad-soyad, profil fotoğrafı ve departman görünür.
- Sağ alttaki **Yeni Kişi** düğmesi formu açar.
- Yeni bir kayıt eklenir ve listeye geri dönünce görünür.
- Kişi satırı açıldığında seçilen kaydın detayları görünür.
- Telefon satırına dokununca arama uygulaması, e-posta satırına dokununca posta uygulaması açılır (cihazda ilgili uygulama tanımlı olmalıdır).
- **DÜZENLE** ile bir alan değiştirilir; kaydedince yeni değer detay ve listede görünür.
- **KİŞİYİ SİL** seçilince onay diyaloğu çıkar. İptal kaydı korur; onay siler ve listeye döner.
- Backend kapalıyken uygulama bağlantı hatasını gösterir; backend yeniden açılınca yenileme ile kayıtlar alınır.

