# Implementation Plan: Halaman Uji Non Parametrik (Sign, Run, Wilcoxon, Mann Whitney U) - RShiny

## 1. Tujuan
Membuat halaman RShiny modular untuk uji non parametrik: Sign, Run, Wilcoxon, dan Mann Whitney U, dengan struktur kode yang mudah dikembangkan dan dipelihara.

## 2. Struktur Modular
- Setiap uji dibuat sebagai modul Shiny terpisah (UI dan server):
  - `mod_sign_test_ui` & `mod_sign_test_server`
  - `mod_run_test_ui` & `mod_run_test_server`
  - `mod_wilcoxon_test_ui` & `mod_wilcoxon_test_server`
  - `mod_mannwhitney_test_ui` & `mod_mannwhitney_test_server`
- Satu file utama (misal: `nonparametric_tests.R` atau bagian dari `app.R`) yang mengintegrasikan semua modul.
- Folder data untuk contoh dataset (jika diperlukan).

## 3. Komponen UI
- Input data: upload file (CSV/XLSX) atau input manual.
- Pilihan jenis uji (radio/dropdown).
- Input parameter spesifik tiap uji (misal: paired/unpaired, kolom mana, dsb).
- Tombol eksekusi uji.
- Output hasil uji: statistik, p-value, interpretasi hasil.
- Visualisasi (boxplot, histogram, dsb jika relevan).
- Penjelasan singkat/metode tiap uji (help/info box).

## 4. Alur Interaksi Pengguna
1. User mengunggah/memasukkan data.
2. User memilih jenis uji.
3. User mengisi parameter uji (jika ada).
4. User menekan tombol eksekusi.
5. Hasil uji dan visualisasi muncul.
6. User dapat membaca penjelasan/metode tiap uji.

## 5. Integrasi Fungsi Statistik R
- **Sign Test:** `BSDA::SIGN.test` atau `DescTools::SignTest`
- **Run Test:** `tseries::runs.test`
- **Wilcoxon Test:** `stats::wilcox.test` (paired/unpaired)
- **Mann Whitney U:** `stats::wilcox.test` (unpaired)
- Semua fungsi dipanggil di masing-masing modul server.

## 6. Dokumentasi & Referensi
- Setiap modul menampilkan penjelasan singkat dan referensi pustaka/fungsi R yang digunakan.
- Dokumentasi aplikasi dan contoh penggunaan di README.

## 7. Referensi & Best Practice
- Modularisasi mengikuti best practice RShiny:
  - [Structuring your R Shiny app using modules (Medium)](https://medium.com/@derilraju/structuring-your-r-shiny-app-using-modules-5a1b5545246c)
  - [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org/structuring-project.html)
- Implementasi uji non parametrik di R:
  - [Mann Whitney U Test in R Programming - GeeksforGeeks](https://www.geeksforgeeks.org/mann-whitney-u-test-in-r-programming/)
  - [Wilcoxon Signed Rank Test in R Programming - GeeksforGeeks](https://www.geeksforgeeks.org/wilcoxon-signed-rank-test-in-r-programming/)
  - [Non-parametric tests in R (YouTube)](https://www.youtube.com/watch?v=iF8nHwLzlxg)

---

**Catatan:**
- Setiap modul dapat dikembangkan dan diuji secara terpisah.
- Struktur modular memudahkan penambahan uji lain di masa depan.
- Pastikan dependensi paket R (BSDA, DescTools, tseries) sudah terinstall.
