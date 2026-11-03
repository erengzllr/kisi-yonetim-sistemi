# Backend API kurulumu

Bu servis Django REST Framework ve SQLite kullanır. Aşağıdaki adımlar Windows PowerShell içindir.

## Kurulum

```powershell
cd backend_api
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python manage.py migrate
```

`py` başlatıcısı yoksa `python -m venv .venv` komutunu kullanın. İlk kurulumdan sonra sanal ortamı etkinleştirip servisi başlatın:

```powershell
cd backend_api
.\.venv\Scripts\Activate.ps1
python manage.py runserver 0.0.0.0:8000
```

API emülatör veya aynı yerel ağa bağlı fiziksel cihazdan erişilebilsin diye `0.0.0.0` üzerinde dinler. Windows Güvenlik Duvarı bağlantıyı sorarsa yerel ağdaki özel ağ erişimine izin verin.

## Uç noktalar

- `GET /api/persons/`
- `GET /api/persons/{id}/`
- `POST /api/persons/`
- `PUT /api/persons/{id}/`
- `DELETE /api/persons/{id}/`

JSON tarihleri `YYYY-MM-DD` biçimindedir. Kişi oluşturma ve güncelleme gövdesinde `fullName`, `department`, `photoUrl`, `birthPlace`, `birthDate`, `email` ve `phone` alanlarını gönderin.

## Geliştirme notu

`DEBUG`, geniş `ALLOWED_HOSTS` ve tüm kaynaklara açık CORS ayarları yerel ders projesi geliştirmesi içindir. Bu ayarlarla servisi internete açık üretim ortamına dağıtmayın.

