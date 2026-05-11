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

<img width="1080" height="2400" alt="Screenshot_20260511_181912" src="https://github.com/user-attachments/assets/f7c42c77-ac3a-49e1-8c2c-1e6e71eb9bec" />


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
