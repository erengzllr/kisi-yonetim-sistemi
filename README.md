# Kişi Yönetim Sistemi

Flutter mobil istemcisi ve Django REST Framework API'si üzerinden kişi kayıtlarını listeler, görüntüler, ekler, günceller ve siler.

## Proje yapısı

```text
mobile_app/   Flutter uygulaması
backend_api/  Django REST Framework servisi
MOBIL_TEST_REHBERI.md  Manuel çalıştırma ve kabul kontrol listesi
```

## Hızlı başlangıç

Kısa Windows kurulum ve çalıştırma adımları için [KISA_CALISTIRMA.md](KISA_CALISTIRMA.md) dosyasına bakın.

1. API'yi kurup çalıştırmak için [backend_api/README.md](backend_api/README.md) adımlarını izleyin.
2. Ayrı bir terminalde `mobile_app` klasörüne geçin ve Flutter bağımlılıklarını alın:

   ```powershell
   cd mobile_app
   flutter pub get
   ```

3. Android emülatöründe uygulamayı başlatın:

   ```powershell
   flutter run --dart-define="API_BASE_URL=http://10.0.2.2:8000/api"
   ```

Fiziksel Android cihazında `10.0.2.2` yerine bilgisayarın yerel ağ IP'sini kullanın. API sunucusu `0.0.0.0:8000` adresinde dinlemeli ve cihaz aynı ağa bağlı olmalıdır. Ayrıntılı adımlar için [MOBIL_TEST_REHBERI.md](MOBIL_TEST_REHBERI.md) dosyasına bakın.

## API uç noktaları

| Metot | Adres | İşlem |
|---|---|---|
| GET | `/api/persons/` | Kişileri listeler |
| GET | `/api/persons/{id}/` | Kişi detayını getirir |
| POST | `/api/persons/` | Kişi oluşturur |
| PUT | `/api/persons/{id}/` | Kişiyi günceller |
| DELETE | `/api/persons/{id}/` | Kişiyi siler |

API `id`, `fullName`, `department`, `photoUrl`, `birthPlace`, `birthDate`, `email` ve `phone` alanlarını JSON olarak kullanır.

