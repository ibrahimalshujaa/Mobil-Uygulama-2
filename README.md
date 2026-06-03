# StyleHub — Berberhane Mobil Uygulaması

> Flutter + Firebase tabanlı berberhane randevu mobil uygulaması. İki kullanıcı modu desteklenmektedir: **Müşteri** ve **Berber (Yönetici Paneli)**.

---

## 📱 Uygulama Görünümü

### Müşteri Navigasyon Akışı
```
Açılış → Karşılama → Giriş / Kayıt
                         ↓
                ┌────────────────────────────────┐
                │     Ana Ekran (Alt Navigasyon)  │
                ├──────────┬──────────┬───────────┤
                │ Ana Sayfa│Randevularım│  Profil  │
                └──────────┴──────────┴───────────┘
                     ↓           ↓           ↓
               Ana Ekran  Randevularım   Profil Ekranı
                     ↓
             ┌───────────────┐
             │  Hizmet Seç   │ → Berber Seç → Rezervasyon → Onay
             ├───────────────┤
             │ Galeriye Git  │ → Galeri Detayı
             ├───────────────┤
             │ Salon Bilgisi │
             ├───────────────┤
             │ Bildirimler   │
             └───────────────┘
```

### Berber Navigasyon Akışı
```
Açılış → BerberAnaEkranı (Alt Navigasyon)
         ┌──────────┬────────────┬──────────┐
         │  Panel   │  Hizmetler │  Profil  │
         └──────────┴────────────┴──────────┘
              ↓            ↓          ↓
        BerberPaneli  HizmetYönetimi  Profil
              ↓
        Bildirimler / Salon Ayarları
```

---

## 🗂️ Proje Klasör Yapısı

```
lib/
├── main.dart                        # Uygulama giriş noktası
├── firebase_options.dart            # Firebase yapılandırması
│
├── constants/                       # Tasarım sabitleri
│   ├── app_colors.dart              # Renk paleti (koyu tema + altın)
│   └── app_text_styles.dart         # Tipografi
│
├── models/                          # Veri modelleri
│   ├── appointment_model.dart       # Randevu verisi
│   ├── barber_model.dart            # Berber verisi
│   ├── hairstyle_model.dart         # Saç modeli verisi
│   ├── notification_model.dart      # Bildirim verisi
│   ├── service_model.dart           # Hizmet verisi
│   └── user_model.dart              # Kullanıcı verisi
│
├── services/                        # İş mantığı & Firebase
│   ├── auth_service.dart            # Giriş, kayıt, çıkış
│   ├── appointment_service.dart     # Randevu CRUD işlemleri
│   ├── notification_service.dart    # Bildirim gönderme & okuma
│   ├── review_service.dart          # Müşteri yorumları
│   ├── salon_service.dart           # Hizmetler & salon ayarları
│   ├── user_service.dart            # Kullanıcı profil güncelleme
│   └── mock_data_service.dart       # Geliştirme için örnek veriler
│
├── widgets/                         # Yeniden kullanılabilir UI bileşenleri
│   ├── appointment_card.dart        # Randevu kartı
│   ├── barber_card.dart             # Berber kartı
│   └── service_card.dart            # Hizmet kartı
│
└── screens/                         # Tüm uygulama ekranları
    │
    │  ── KİMLİK DOĞRULAMA ──
    ├── splash_screen.dart           # Açılış ekranı (otomatik giriş kontrolü)
    ├── welcome_screen.dart          # Hoş geldiniz sayfası
    ├── login_screen.dart            # Giriş formu
    ├── register_screen.dart         # Kayıt formu
    │
    │  ── MÜŞTERİ MENÜSÜ ──
    ├── main_screen.dart             # [Nav] Ana Sayfa / Randevularım / Profil
    ├── home_screen.dart             # Sekme: Ana Sayfa
    ├── my_appointments_screen.dart  # Sekme: Randevularım (randevu listesi)
    ├── appointment_detail_screen.dart  # Randevu detayı & iptal
    │
    │  ── REZERVASYON AKIŞI ──
    ├── service_selection_screen.dart   # Adım 1: Hizmet Seç
    ├── barber_selection_screen.dart    # Adım 2: Berber Seç
    ├── booking_screen.dart             # Adım 3: Tarih & Saat Seç
    ├── confirmation_screen.dart        # Adım 4: Onayla & Öde
    │
    │  ── SALON BİLGİSİ ──
    ├── shop_info_screen.dart        # Salon bilgisi, adres, çalışma saatleri
    ├── gallery_screen.dart          # Saç modeli galerisi
    ├── gallery_detail_screen.dart   # Saç modeli detayı
    ├── barber_detail_screen.dart    # Berber profili & yorumlar
    ├── reviews_screen.dart          # Müşteri yorumları listesi
    ├── notifications_screen.dart    # Müşteri bildirimleri
    │
    │  ── BERBER PANELİ ──
    ├── barber_main_screen.dart      # [Nav] Panel / Hizmetler / Profil
    ├── barber_panel_screen.dart     # Sekme: Panel (gelen randevular, istatistikler)
    ├── service_management_screen.dart  # Sekme: Hizmetler (hizmet yönetimi)
    ├── barber_notifications_screen.dart  # Berber bildirimleri
    ├── salon_settings_screen.dart   # Salon ayarları (isim, saatler, vb.)
    │
    │  ── ORTAK (Müşteri & Berber tarafından kullanılır) ──
    ├── profile_screen.dart          # Sekme: Profil (müşteri & berber)
    ├── edit_profile_screen.dart     # Profil düzenleme
    └── admin_screen.dart            # Yönetici paneli (yalnızca admin rolü)
```

---

## ✨ Temel Özellikler

### 👤 Müşteri
| Özellik | Açıklama |
|---|---|
| **Kimlik Doğrulama** | Firebase Auth ile Giriş / Kayıt / Çıkış |
| **Hizmetleri Görüntüle** | Fiyat & süre bilgisiyle hizmet listesi, arama desteği |
| **Randevu Al** | Hizmet → berber → tarih & saat → onay akışı |
| **Randevularım** | Tüm aktif randevuları & geçmişi görüntüle |
| **İptal Et** | Aktif randevuyu iptal et |
| **Yorum Yap** | Tamamlanan randevu sonrası yıldız puanı & yorum |
| **Galeri** | Saç modellerini & bakım ipuçlarını görüntüle |
| **Salon Bilgisi** | Adres, telefon, çalışma saatleri, Instagram, WhatsApp |
| **Bildirimler** | Randevu durum güncellemelerini gerçek zamanlı al |

### ✂️ Berber
| Özellik | Açıklama |
|---|---|
| **Panel Gösterge Tablosu** | Bugünkü randevuları & istatistikleri görüntüle |
| **Randevu Yönetimi** | Randevuları onayla / tamamla / iptal et |
| **Hizmet Yönetimi** | Hizmet & fiyat ekle, düzenle, aktif/pasif yap |
| **Salon Ayarları** | Salon adı, açıklama, çalışma saatleri, iletişim güncelle |
| **Bildirimler** | Yeni rezervasyon & yorum bildirimlerini al |
| **Profil** | Berber profil bilgilerini düzenle |

---

## 🛠️ Teknoloji Yığını

| Teknoloji | Sürüm | Kullanım Amacı |
|---|---|---|
| **Flutter** | 3.41.9 (stable) | Ana framework |
| **Dart** | ^3.11.4 | Programlama dili |
| **Firebase Auth** | ^6.5.1 | Kullanıcı kimlik doğrulama |
| **Cloud Firestore** | ^6.4.1 | Gerçek zamanlı veritabanı |
| **Firebase Core** | ^4.9.0 | Firebase başlatma |
| **intl** | ^0.20.2 | Tarih & sayı biçimlendirme |
| **table_calendar** | ^3.2.0 | Tarih seçimi takvimi |
| **flutter_rating_bar** | ^4.0.1 | Yorum yıldız puanı |
| **fl_chart** | ^1.2.0 | Berber paneli istatistik grafikleri |
| **http** | ^1.6.0 | HTTP istekleri |

---

## 🚀 Nasıl Çalıştırılır

### Ön Koşullar
- Flutter SDK ≥ 3.41.9
- Android Studio / VS Code
- Yapılandırılmış bir Firebase projesi
- Android veya iOS cihaz/emülatör

### Adımlar

```bash
# 1. Depoyu klonla
git clone <repository-url>
cd Mobil-Uygulama-2

# 2. Bağımlılıkları yükle
flutter pub get

# 3. Uygulamayı çalıştır
flutter run

# 4. APK derle (isteğe bağlı)
flutter build apk --release
```

### Firebase Yapılandırması
1. [Firebase Console](https://console.firebase.google.com) üzerinde proje oluştur
2. `com.example.style_hub` paket adıyla Android uygulaması ekle
3. `google-services.json` dosyasını indir → `android/app/` dizinine koy
4. **Authentication** (E-posta/Şifre) ve **Cloud Firestore**'u etkinleştir
5. Firestore kurallarını ihtiyaca göre ayarla

---

## 🎨 Tasarım & Tema

Uygulama, altın vurgularla **koyu tema** kullanmaktadır:

| Öğe | Renk |
|---|---|
| Ana arka plan | `#0F0F0F` (koyu siyah) |
| Kart arka planı | `#1A1A2E` |
| Ana vurgu (altın) | `#C9A84C` |
| Ana metin | `#F5F5F5` |
| İkincil metin | `#A0A0A0` |

---

## 📂 Veritabanı Yapısı (Firestore)

```
firestore/
├── users/{uid}
│   ├── uid, name, email, phone
│   └── role: "customer" | "barber" | "admin"
│
├── appointments/{id}
│   ├── userId, userName
│   ├── barberId, barberName
│   ├── serviceId, serviceName, price
│   ├── date, time
│   ├── status: "Bekliyor" | "Onaylandı" | "Tamamlandı" | "İptal Edildi"
│   └── createdAt
│
├── services/{id}
│   ├── name, description
│   ├── duration (dakika), price
│   ├── isActive
│   └── createdAt
│
├── notifications/{id}
│   ├── userId, roleTarget
│   ├── title, message, type
│   ├── appointmentId
│   └── createdAt
│
├── reviews/{id}
│   ├── appointmentId, userId, userName
│   ├── serviceName
│   ├── rating (1–5), comment
│   └── createdAt
│
└── salon_settings/config
    ├── salonName, about
    ├── address, phone
    ├── workingHours
    ├── instagram, whatsapp
    └── updatedAt
```

---

## 📋 Android Derleme Yapılandırması

| Bileşen | Sürüm |
|---|---|
| Gradle | 8.7 |
| Android Gradle Plugin (AGP) | 8.5.2 |
| Kotlin | 2.0.21 |
| compileSdk | Flutter varsayılanı |
| minSdk | Flutter varsayılanı |
| Java | 17 |

---

## 👥 Kullanıcı Rolleri

| Rol | Erişim |
|---|---|
| `customer` | Randevu al, galeriyi görüntüle, yorum yap, bildirimler |
| `barber` | Randevu yönetimi, hizmet yönetimi, salon ayarları, bildirimler |
| `admin` | Tüm berber erişimi + yönetici paneli |

---

## 📝 Lisans

Bu proje kişisel/akademik amaçlar için oluşturulmuştur. İzinsiz dağıtımı yasaktır.
