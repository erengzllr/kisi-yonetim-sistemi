# Kısa kurulum ve çalıştırma

## Gerekenler

- Windows 10/11
- Python 3.10 veya üstü
- Flutter ve Dart 3 uyumlu sürüm
- Android Studio ile Android SDK Platform 36, Android SDK Build-Tools 36 ve Platform-Tools
- Android emülatörü veya USB hata ayıklama açık Android cihaz

`android/local.properties` pakete konmaz; Flutter, yeni bilgisayarın Flutter ve Android SDK yollarını kullanarak bunu oluşturur.

## 1. Backend'i başlatın

PowerShell'de proje kökünden:

```powershell
cd backend_api
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

İlk kurulum boş bir SQLite veritabanı oluşturur. Veritabanı dosyası taşınmaz; şema `backend_api/api/migrations/` içindeki migration'larla kurulur.

## 2. Android uygulamasını başlatın

İkinci PowerShell penceresinde proje kökünden:

```powershell
cd mobile_app
flutter pub get
flutter devices
flutter run --dart-define="API_BASE_URL=http://10.0.2.2:8000/api"
```

Emülatörde `10.0.2.2`, bilgisayarın `localhost` adresine karşılık gelir. Fiziksel cihazda bu adresi bilgisayarın yerel ağ IP'siyle değiştirin; telefon ve bilgisayar aynı ağa bağlı olmalı, backend `0.0.0.0:8000` üzerinde çalışmalıdır.

## Hazır APK

`TESLIM_PAKETI` klasöründe kaynak ZIP'inden ayrı verilen `KisiRehberi-debug.apk`, emülatör için `http://10.0.2.2:8000/api` adresini kullanır. APK'yı kurmadan önce backend'i yukarıdaki gibi başlatın. Fiziksel cihaz veya farklı sunucu için APK'yı kaynak koddan `--dart-define=API_BASE_URL=...` ile yeniden derleyin:

```powershell
flutter build apk --debug --dart-define="API_BASE_URL=http://10.0.2.2:8000/api"
```

Detaylı manuel kontrol sırası için `MOBIL_TEST_REHBERI.md` dosyasına bakın.
