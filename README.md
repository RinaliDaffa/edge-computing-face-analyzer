# Edge AI Face Analyzer

Aplikasi Flutter sederhana untuk mendeteksi wajah dan ekspresi dari foto galeri. Semua proses AI berjalan langsung di HP (Edge Computing), tanpa internet.

## Fitur

- Pilih foto dari galeri
- Deteksi wajah manusia
- Baca ekspresi senyum (dengan persentase)
- Baca kondisi mata kiri dan mata kanan (terbuka/tertutup dengan persentase)
- Mendeteksi lebih dari satu wajah sekaligus

## Cara Pakai

1. Jalankan aplikasi
2. Tekan tombol **"Pilih Foto dari Galeri"**
3. Pilih foto yang jelas menampilkan wajah
4. Lihat hasil deteksi wajah dan ekspresi

## Screenshot

<!-- Tempatkan screenshot aplikasi di bawah ini -->
```
┌─────────────────────────────────┐
│                                 │
│     [Screenshot 1: Awal App]    │
│        (appawal.png)            │
│                                 │
└─────────────────────────────────┘
```

```
┌─────────────────────────────────┐
│                                 │
│  [Screenshot 2: Hasil Deteksi]   │
│        (hasildeteksi.png)       │
│                                 │
└─────────────────────────────────┘
```

## Teknologi

- **Flutter** - Framework aplikasi
- **Google ML Kit Face Detection** - Deteksi wajah (on-device)
- **image_picker** - Akses foto galeri

## Instalasi

```bash
flutter pub get
flutter run
```

## Catatan

- Semua proses AI berjalan offline (tanpa internet)
- Pakai foto yang jelas untuk hasil terbaik
- Hasil deteksi paling akurat untuk foto dengan pencahayaan yang baik