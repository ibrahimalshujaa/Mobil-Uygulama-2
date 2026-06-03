# StyleHub — Barber Shop Mobile App

> Aplikasi mobile pemesanan layanan barbershop berbasis Flutter + Firebase, dengan dua mode pengguna: **Customer** dan **Barber (Panel Admin)**.

---

## 📱 Tampilan Aplikasi

### Alur Navigasi Customer
```
Splash → Welcome → Login / Register
                        ↓
               ┌────────────────────────────────┐
               │     Main Screen (Bottom Nav)    │
               ├──────────┬──────────┬───────────┤
               │ Ana Sayfa│Randevularım│  Profil  │
               └──────────┴──────────┴───────────┘
                    ↓           ↓           ↓
              Home Screen  My Appts   Profile Screen
                    ↓
            ┌───────────────┐
            │  Hizmet Seç   │ → Berber Seç → Booking → Konfirmasyon
            ├───────────────┤
            │ Galeriye Git  │ → Gallery Detail
            ├───────────────┤
            │ Salon Bilgisi │
            ├───────────────┤
            │ Bildirimler   │
            └───────────────┘
```

### Alur Navigasi Barber
```
Splash → BarberMainScreen (Bottom Nav)
         ┌──────────┬────────────┬──────────┐
         │  Panel   │  Hizmetler │  Profil  │
         └──────────┴────────────┴──────────┘
              ↓            ↓          ↓
        BarberPanel  ServiceMgmt  Profile
              ↓
        Bildirimler / Salon Ayarları
```

---

## 🗂️ Struktur Folder Proyek

```
lib/
├── main.dart                        # Entry point aplikasi
├── firebase_options.dart            # Konfigurasi Firebase
│
├── constants/                       # Konstanta desain
│   ├── app_colors.dart              # Palet warna (dark theme + gold)
│   └── app_text_styles.dart         # Tipografi
│
├── models/                          # Model data
│   ├── appointment_model.dart       # Data randevu/appointment
│   ├── barber_model.dart            # Data berber
│   ├── hairstyle_model.dart         # Data model gaya rambut
│   ├── notification_model.dart      # Data notifikasi
│   ├── service_model.dart           # Data layanan/hizmet
│   └── user_model.dart              # Data pengguna
│
├── services/                        # Logika bisnis & Firebase
│   ├── auth_service.dart            # Login, register, logout
│   ├── appointment_service.dart     # CRUD randevu
│   ├── notification_service.dart    # Push & baca notifikasi
│   ├── review_service.dart          # Ulasan pelanggan
│   ├── salon_service.dart           # Layanan & pengaturan salon
│   ├── user_service.dart            # Update profil pengguna
│   └── mock_data_service.dart       # Data dummy untuk development
│
├── widgets/                         # Komponen UI reusable
│   ├── appointment_card.dart        # Kartu randevu
│   ├── barber_card.dart             # Kartu berber
│   └── service_card.dart            # Kartu layanan
│
└── screens/                         # Semua layar aplikasi
    │
    │  ── AUTH (Autentikasi) ──
    ├── splash_screen.dart           # Layar pembuka (cek login otomatis)
    ├── welcome_screen.dart          # Halaman selamat datang
    ├── login_screen.dart            # Form login
    ├── register_screen.dart         # Form registrasi
    │
    │  ── CUSTOMER MENU ──
    ├── main_screen.dart             # [Nav] Ana Sayfa / Randevularım / Profil
    ├── home_screen.dart             # Tab: Ana Sayfa
    ├── my_appointments_screen.dart  # Tab: Randevularım (daftar randevu)
    ├── appointment_detail_screen.dart  # Detail & batalkan randevu
    │
    │  ── BOOKING FLOW (Alur Pemesanan) ──
    ├── service_selection_screen.dart   # Langkah 1: Pilih Layanan
    ├── barber_selection_screen.dart    # Langkah 2: Pilih Berber
    ├── booking_screen.dart             # Langkah 3: Pilih Tanggal & Jam
    ├── confirmation_screen.dart        # Langkah 4: Konfirmasi & Bayar
    │
    │  ── INFORMASI SALON ──
    ├── shop_info_screen.dart        # Info salon, alamat, jam buka
    ├── gallery_screen.dart          # Galeri gaya rambut
    ├── gallery_detail_screen.dart   # Detail model rambut
    ├── barber_detail_screen.dart    # Profil berber & ulasan
    ├── reviews_screen.dart          # Daftar ulasan pelanggan
    ├── notifications_screen.dart    # Notifikasi pelanggan
    │
    │  ── BARBER PANEL ──
    ├── barber_main_screen.dart      # [Nav] Panel / Hizmetler / Profil
    ├── barber_panel_screen.dart     # Tab: Panel (randevu masuk, statistik)
    ├── service_management_screen.dart  # Tab: Hizmetler (kelola layanan)
    ├── barber_notifications_screen.dart  # Notifikasi berber
    ├── salon_settings_screen.dart   # Pengaturan salon (nama, jam, dll)
    │
    │  ── SHARED (Digunakan Customer & Barber) ──
    ├── profile_screen.dart          # Tab: Profil (customer & barber)
    ├── edit_profile_screen.dart     # Edit data profil
    └── admin_screen.dart            # Panel admin (khusus role admin)
```

---

## ✨ Fitur Utama

### 👤 Customer
| Fitur | Keterangan |
|---|---|
| **Autentikasi** | Login / Register / Logout via Firebase Auth |
| **Lihat Layanan** | Daftar layanan dengan harga & durasi, bisa dicari |
| **Pesan Randevu** | Pilih layanan → berber → tanggal & jam → konfirmasi |
| **Randevularım** | Lihat semua randevu aktif & riwayat |
| **Batalkan** | Batalkan randevu yang masih aktif |
| **Beri Ulasan** | Rating bintang & komentar setelah randevu selesai |
| **Galeri** | Lihat model rambut & tips perawatan |
| **Info Salon** | Alamat, telepon, jam buka, Instagram, WhatsApp |
| **Notifikasi** | Terima update status randevu secara real-time |

### ✂️ Barber
| Fitur | Keterangan |
|---|---|
| **Panel Dashboard** | Lihat randevu masuk hari ini & statistik |
| **Kelola Randevu** | Terima / selesaikan / batalkan randevu |
| **Kelola Layanan** | Tambah, edit, aktif/nonaktif layanan & harga |
| **Pengaturan Salon** | Update nama salon, deskripsi, jam buka, kontak |
| **Notifikasi** | Terima notifikasi pemesanan & ulasan baru |
| **Profil** | Edit data profil berber |

---

## 🛠️ Tech Stack

| Teknologi | Versi | Kegunaan |
|---|---|---|
| **Flutter** | 3.41.9 (stable) | Framework utama |
| **Dart** | ^3.11.4 | Bahasa pemrograman |
| **Firebase Auth** | ^6.5.1 | Autentikasi pengguna |
| **Cloud Firestore** | ^6.4.1 | Database real-time |
| **Firebase Core** | ^4.9.0 | Inisialisasi Firebase |
| **intl** | ^0.20.2 | Format tanggal & angka |
| **table_calendar** | ^3.2.0 | Kalender pilih tanggal |
| **flutter_rating_bar** | ^4.0.1 | Bintang rating ulasan |
| **fl_chart** | ^1.2.0 | Grafik statistik di panel berber |
| **http** | ^1.6.0 | HTTP requests |

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK ≥ 3.41.9
- Android Studio / VS Code
- Firebase project yang sudah dikonfigurasi
- Device/emulator Android atau iOS

### Langkah-langkah

```bash
# 1. Clone repositori
git clone <repository-url>
cd Mobil-Uygulama-2

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run

# 4. Build APK (opsional)
flutter build apk --release
```

### Konfigurasi Firebase
1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Tambahkan Android app dengan package `com.example.style_hub`
3. Download `google-services.json` → taruh di `android/app/`
4. Aktifkan **Authentication** (Email/Password) dan **Cloud Firestore**
5. Set Firestore rules sesuai kebutuhan

---

## 🎨 Desain & Tema

Aplikasi menggunakan **dark theme** dengan aksen gold:

| Elemen | Warna |
|---|---|
| Background utama | `#0F0F0F` (hitam gelap) |
| Background kartu | `#1A1A2E` |
| Aksen utama (gold) | `#C9A84C` |
| Teks utama | `#F5F5F5` |
| Teks sekunder | `#A0A0A0` |

---

## 📂 Database Structure (Firestore)

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
│   ├── duration (menit), price
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

## 📋 Android Build Config

| Komponen | Versi |
|---|---|
| Gradle | 8.7 |
| Android Gradle Plugin (AGP) | 8.5.2 |
| Kotlin | 2.0.21 |
| compileSdk | Flutter default |
| minSdk | Flutter default |
| Java | 17 |

---

## 👥 Role Pengguna

| Role | Akses |
|---|---|
| `customer` | Pesan randevu, lihat galeri, beri ulasan, notifikasi |
| `barber` | Kelola randevu, kelola layanan, pengaturan salon, notifikasi |
| `admin` | Semua akses barber + panel admin |

---

## 📝 Lisensi

Project ini dibuat untuk keperluan pribadi/akademik. Dilarang didistribusikan tanpa izin.
