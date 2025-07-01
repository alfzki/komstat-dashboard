# Dokumentasi Membaca Kode Proyek Komstat (Front End & Back End)

## 1. Pengantar
Dokumentasi ini dibuat untuk membantu kamu memahami cara membaca kode pada proyek ini, baik bagian front end (tampilan web) maupun back end (server/API). Penjelasan disusun untuk pemula yang hanya paham dasar HTML/CSS/JS dan R, tanpa pengalaman framework/library modern.

---

## 2. Framework & Library yang Digunakan

### Front End
- **React**: Library JavaScript untuk membang---

## 11. Tips Debugging ---

## 12. Cara Menambah Fitur Baru

### 12.1. Menambah Endpoint Baru di Back End Pemula

### 11.1. Debug Front Endtarmuka pengguna (UI) berbasis komponen.
- **TypeScript**: Bahasa pemrograman berbasis JavaScript, tapi dengan tipe data statis (membantu mencegah bug).
- **Material UI (MUI)**: Library komponen UI siap pakai yang mengikuti desain Material Google.

### Back End
- **R**: Bahasa pemrograman statistik.
- **Plumber**: Library R untuk membuat REST API (server yang bisa diakses dari aplikasi lain, misal front end).

---

## 3. Struktur Folder & File Penting

### Front End (`/frontend`)
- `src/` : Semua kode utama aplikasi React.
  - `App.tsx` : Titik awal aplikasi, mengatur routing (halaman mana yang tampil).
  - `index.tsx` : Memulai aplikasi dan menempelkan ke HTML.
  - `components/` : Kumpulan "komponen" (bagian UI terpisah, seperti tombol, grafik, dsb).
  - `theme/` : Pengaturan tema warna dan tampilan.
  - `utils/` : Fungsi-fungsi pembantu.
- `public/index.html` : HTML utama, React akan "menempel" di sini.
- `package.json` : Daftar library yang dipakai.

### Back End (`/server`)
- `api.R` : Kode utama API Plumber (mengatur endpoint, load data, dsb).
- `run.R` : Menjalankan server API.
- `data/` : Kumpulan file data (CSV, JSON) yang digunakan API.

---

## 4. Cara Membaca Kode Front End

1. **Mulai dari `App.tsx`**
   - File ini menentukan halaman apa saja yang ada (misal: `/`, `/dashboard`, `/analysis`).
   - Setiap halaman dihubungkan ke komponen, misal `<Dashboard />`.

2. **Lihat Komponen di `components/`**
   - Setiap file di sini adalah bagian UI, misal: `ChartUserByCountry.tsx` (grafik), `SideMenu.tsx` (menu samping).
   - Komponen biasanya berupa fungsi yang mengembalikan kode mirip HTML (disebut JSX).

3. **Perhatikan Props dan State**
   - Props: Data yang dikirim ke komponen dari "luar".
   - State: Data lokal di dalam komponen, bisa berubah (misal: hasil fetch API).

4. **Alur Data**
   - Data biasanya diambil dari API (back end) pakai `fetch` atau library lain.
   - Hasil fetch disimpan di state, lalu ditampilkan di UI.

5. **TypeScript**
   - Mirip JavaScript, tapi ada tipe data. Contoh: `const x: number = 5;`

6. **Material UI**
   - Komponen seperti `<Button>`, `<Card>`, dsb. berasal dari MUI, sudah punya style bawaan.

---

## 5. Cara Membaca Kode Back End

1. **File `api.R`**
   - Menggunakan library `plumber` untuk membuat API.
   - Data di-load dari file JSON/CSV di folder `data/`.
   - Fungsi-fungsi di sini biasanya diawali dengan `#* @get /nama-endpoint` (menandakan endpoint API).

2. **File `run.R`**
   - Menjalankan server API di port tertentu (misal: 8000).
   - Mengaktifkan CORS agar bisa diakses dari front end.

3. **Alur Data**
   - Ketika front end butuh data, ia akan mengakses endpoint API (misal: `http://localhost:8000/data`), lalu API akan membaca file data dan mengirimkan hasilnya ke front end.

---

## 5.1. Penjelasan Endpoint API yang Tersedia

Back end memiliki beberapa endpoint yang dapat diakses oleh front end:

1. **`/countries`** - Mengembalikan daftar negara
2. **`/global-complete-data.json`** - Data lengkap emisi global
3. **`/statistics`** - Statistik berdasarkan negara dan tahun
4. **`/map-data`** - Data untuk visualisasi peta
5. **`/growth`** - Data pertumbuhan emisi
6. **`/country-code-and-numeric.json`** - Mapping kode negara

Setiap endpoint memiliki parameter tertentu (misal: `country_code`, `start_year`, `end_year`) yang dikirim dari front end.

---

## 6. Alur Data Front End <-> Back End

1. **Front end** (React) melakukan request ke **back end** (Plumber API di R) menggunakan HTTP (biasanya `fetch`).
2. **Back end** membaca data dari file, memproses jika perlu, lalu mengirimkan hasilnya dalam format JSON.
3. **Front end** menerima data, menyimpannya di state, lalu menampilkan di UI.

---

## 7. Tips Membaca & Debugging

- Mulai dari file utama (`App.tsx` untuk front end, `api.R` untuk back end).
- Ikuti alur pemanggilan fungsi/komponen.
- Untuk front end, cari tahu dari mana data diambil (lihat fetch/API call).
- Untuk back end, cek endpoint apa saja yang tersedia (lihat `@get`, `@post` di `api.R`).
- Gunakan console.log (JS) atau print (R) untuk debugging.
- Baca dokumentasi resmi jika bingung:
  - [React](https://react.dev/)
  - [TypeScript](https://www.typescriptlang.org/docs/)
  - [Material UI](https://mui.com/)
  - [Plumber R](https://www.rplumber.io/)

---

## 8. Glosarium Singkat
- **Component**: Bagian UI terpisah di React.
- **Props**: Data yang dikirim ke component.
- **State**: Data lokal di component yang bisa berubah.
- **Hook**: Function khusus React (useState, useEffect) untuk kelola state dan lifecycle.
- **Endpoint**: Alamat API yang bisa diakses front end.
- **API**: Cara aplikasi berkomunikasi (misal: front end minta data ke back end).
- **JSX**: Sintaks yang mirip HTML tapi di JavaScript.
- **Material-UI (MUI)**: Library komponen UI yang sudah jadi (Button, Card, dll).
- **Responsive**: Tampilan yang menyesuaikan ukuran layar.
- **Callback**: Function yang dikirim sebagai parameter ke component lain.
- **Fetch**: Cara JavaScript mengambil data dari API.
- **JSON**: Format data yang digunakan untuk komunikasi API.
- **CORS**: Pengaturan agar browser bisa akses API dari domain berbeda.

---

## 13. File-file Penting yang Perlu Diperhatikan

### 13.1. Front End
- **`package.json`**: Daftar library yang digunakan project
- **`src/App.tsx`**: File utama routing
- **`src/Dashboard.tsx`**: Halaman dashboard utama
- **`src/components/MainGrid.jsx`**: Komponen terbesar, berisi semua konten
- **`src/theme/`**: Folder untuk kustomisasi tema dan styling
- **`public/index.html`**: File HTML utama yang dimuat browser

### 13.2. Back End
- **`server/api.R`**: Semua endpoint API
- **`server/run.R`**: Script untuk menjalankan server
- **`server/data/`**: Folder berisi semua file data (JSON, CSV)

### 13.3. Cara Menjalankan Project

#### Menjalankan Back End (R):
```r
# Di R console atau RStudio
setwd("path/to/project/server")
source("run.R")
```

#### Menjalankan Front End (React):
```bash
# Di terminal, masuk ke folder frontend
cd frontend
npm install    # Install dependencies (hanya pertama kali)
npm start      # Jalankan development server
```

---

Dokumentasi ini memberikan pemahaman mendalam tentang struktur dan cara kerja project. Dengan memahami konsep-konsep di atas, Anda dapat mulai membaca, memahami, dan memodifikasi kode sesuai kebutuhan!

---

## 9. Penjelasan Komponen Front End yang Ada

### 9.1. Komponen Utama

#### **App.tsx** - Router Utama
- **Fungsi**: Mengatur routing antar halaman (Landing, Dashboard, Analysis)
- **Yang perlu dipahami**: 
  - Menggunakan `react-router-dom` untuk navigasi
  - `<Routes>` berisi daftar halaman yang bisa diakses
  - `<Route path='/dashboard' element={<Dashboard />} />` artinya jika user buka `/dashboard`, tampilkan komponen `Dashboard`

#### **Landing.jsx** - Halaman Depan
- **Fungsi**: Halaman pertama yang dilihat user
- **Isi**: Hero section dengan judul, deskripsi, dan tombol "Masuk ke Dashboard"
- **Yang perlu dipahami**: 
  - Menggunakan Material-UI untuk styling (`Typography`, `Button`, `Box`)
  - Button menggunakan `Link` dari react-router untuk navigasi

#### **Dashboard.tsx** - Halaman Dashboard Utama
- **Fungsi**: Container utama untuk semua visualisasi data
- **Yang perlu dipahami**:
  - Mengatur tema dengan `AppTheme`
  - Menampilkan `AppAppBar` (navbar) yang bisa hilang saat scroll
  - Memanggil `MainGrid` yang berisi semua konten utama
  - Menggunakan responsive layout dengan Material-UI

### 9.2. Komponen Navigasi

#### **AppAppBar.tsx** - Navigation Bar
- **Fungsi**: Menu navigasi atas dengan logo dan tombol-tombol
- **Yang perlu dipahami**:
  - Responsive: tampilan berbeda untuk desktop dan mobile
  - Punya fitur scroll effect (hilang saat scroll ke bawah)
  - Berisi tombol download data dan navigasi ke section tertentu

### 9.3. Komponen Konten Utama

#### **MainGrid.jsx** - Container Semua Konten
- **Fungsi**: Komponen terbesar yang menampung semua visualisasi dan data
- **Yang perlu dipahami**:
  - Mengambil data dari API menggunakan `fetch()`
  - Menggunakan React hooks: `useState` untuk menyimpan data, `useEffect` untuk fetch data
  - Membagi tampilan menjadi beberapa section dengan navigasi Table of Contents
  - Memiliki form untuk simulasi update data
  - Menampilkan statistik dalam bentuk cards

### 9.4. Komponen Visualisasi Data

#### **StatCard.tsx** - Kartu Statistik
- **Fungsi**: Menampilkan satu jenis statistik (Total, CO2, CH4, N2O) dalam bentuk card
- **Yang perlu dipahami**:
  - Menerima props: title, value, trend, data untuk chart mini
  - Menampilkan angka utama, persentase pertumbuhan, dan grafik kecil
  - Warna dan ikon berubah berdasarkan trend (naik/turun)

#### **SessionsChart.tsx** - Chart Utama Gas Rumah Kaca
- **Fungsi**: Grafik line chart yang menampilkan tren emisi dari waktu ke waktu
- **Yang perlu dipahami**:
  - Menggunakan `@mui/x-charts` untuk membuat chart
  - Fetch data dari API endpoint `/statistics`
  - Menampilkan 4 line untuk setiap gas (Total, CO2, CH4, N2O)

#### **PageViewsBarChart.jsx** - Bar Chart Persentase
- **Fungsi**: Bar chart yang menampilkan persentase kontribusi setiap gas
- **Yang perlu dipahami**:
  - Menggunakan BarChart dari Material-UI
  - Ada dropdown untuk memilih tipe stacking (percentage, normal)
  - Data dihitung sebagai persentase dari total

#### **MapScatterHeatChartandOther.jsx** - Peta Choropleth
- **Fungsi**: Peta dunia yang menampilkan emisi per negara dengan warna
- **Yang perlu dipahami**:
  - Menggunakan library `react-simple-maps` untuk peta
  - Ada slider untuk memilih tahun
  - Dropdown untuk memilih jenis gas
  - Warna negara berubah berdasarkan tingkat emisi

#### **yoYChartAndGauge.jsx** - Chart Year-over-Year Growth
- **Fungsi**: Menampilkan pertumbuhan tahunan dalam bentuk bar chart dan gauge
- **Yang perlu dipahami**:
  - Autocomplete untuk pilih negara
  - Date picker untuk pilih rentang tahun
  - Gauge chart menampilkan persentase pertumbuhan

### 9.5. Komponen Filter dan Form

#### **CountryYearFilter.tsx** - Filter Negara dan Tahun
- **Fungsi**: Komponen untuk memilih negara dan rentang tahun
- **Yang perlu dipahami**:
  - Autocomplete untuk pilih negara dari API
  - Date range picker untuk pilih rentang tahun
  - Mengirim data ke parent component melalui callback functions

#### **CustomizedDataGrid.tsx** - Tabel Data
- **Fungsi**: Tabel yang menampilkan data detail dalam format grid
- **Yang perlu dipahami**:
  - Menggunakan `@mui/x-data-grid` untuk tabel advanced
  - Fitur sorting, filtering, pagination otomatis
  - Data diambil dari custom hook `useEmissionData`

### 9.6. Komponen Utilitas

#### **useCountries.ts** - Custom Hook
- **Fungsi**: Hook untuk mengambil daftar negara dari API
- **Yang perlu dipahami**:
  - Custom hook menggunakan `useState` dan `useEffect`
  - Mengembalikan list negara, loading state, dan error state
  - Bisa digunakan di berbagai komponen

#### **sessionManager.js** - Manajemen Session
- **Fungsi**: Utility untuk menyimpan preferensi user (country, year range)
- **Yang perlu dipahami**:
  - Menggunakan localStorage untuk simpan data
  - Functions untuk get/set country dan year range
  - Data persisten walaupun page di-refresh

---

## 10. Konfigurasi Koneksi Frontend ↔ Backend

### 10.1. **IMPORTANT: Konfigurasi Koneksi API Sudah Dimigrasikan**

✅ **SEMUA pemanggilan API di frontend kini sudah menggunakan environment variable `.env` (`REACT_APP_API_BASE`).**

**Backend Server:**
- **Host**: `127.0.0.1` 
- **Port**: `8000`
- **File konfigurasi**: `server/run.R` (line 19: `pr$run(port = 8000, host = "127.0.0.1")`)

**Frontend API Calls (SUDAH KONSISTEN):**
- Semua file frontend yang melakukan fetch ke backend kini menggunakan:
  ```js
  const API_BASE = process.env.REACT_APP_API_BASE || 'http://127.0.0.1:8000';
  fetch(`${API_BASE}/endpoint`)
  ```
- Tidak ada lagi hardcoded `localhost:8000` atau `127.0.0.1:8000` di kode.
- Konfigurasi alamat backend kini cukup diubah di file `.env` pada folder `frontend`:
  ```env
  REACT_APP_API_BASE=http://127.0.0.1:8000
  ```
- Setelah mengubah `.env`, restart development server agar perubahan terbaca.

**Keuntungan:**
- Lebih mudah deploy ke server manapun (cukup ubah `.env`)
- Tidak perlu edit banyak file jika backend pindah alamat/port
- Mengurangi risiko bug akibat inconsistency address/port

**Catatan:**
- React (Create React App) sudah mendukung `.env` secara default, variabel harus diawali `REACT_APP_` agar bisa diakses di kode.

---

## 10.2. File-file yang Melakukan API Calls

#### **MainGrid.jsx** - Komponen Utama Data Fetching
**Lokasi API Calls:**
```jsx
// Line 111: Fetch countries untuk dropdown
const response = await fetch('http://127.0.0.1:8000/countries');

// Line 246: Fetch countries untuk mendapatkan country code  
const countriesRes = await fetch('http://127.0.0.1:8000/countries');

// Line 254: Fetch statistics berdasarkan filter
const statsRes = await fetch(`http://127.0.0.1:8000/statistics?country_code=${code}&start_year=${yearRange[0]}&end_year=${yearRange[1]}`);
```

#### **SessionsChart.tsx** - Chart Utama Gas Rumah Kaca
```jsx
// Line 57: Fetch data untuk line chart
const response = await fetch(`http://127.0.0.1:8000/statistics?country_code=WLD&start_year=${yearRange[0]}&end_year=${yearRange[1]}`);
```

#### **MapScatterHeatChartandOther.jsx** - Peta Choropleth
```jsx  
// Line 41: Fetch mapping kode negara (SALAH - gunakan 127.0.0.1)
fetch("http://localhost:8000/country-code-and-numeric.json")

// Line 62: Fetch data peta (SALAH - gunakan 127.0.0.1)  
const res = await fetch(`http://localhost:8000/map-data?year=${selectedYear}&gas_type=${selectedGas}`);
```

#### **yoYChartAndGauge.jsx** - Chart Year-over-Year Growth
```jsx
// Line 25: Environment variable dengan default SALAH
const API_BASE = process.env.REACT_APP_API_BASE || 'http://localhost:8000';

// Lines 63, 77, 115-116: Menggunakan API_BASE
const res = await fetch(`${API_BASE}/countries`);
const res = await fetch(`${API_BASE}/growth?country_code=${countryCode}&start_year=${startYear}&end_year=${endYear}`);
```

#### **useCountries.ts** - Custom Hook untuk Countries
```jsx
// Line 15: Fetch countries list  
fetch('http://127.0.0.1:8000/countries')
```

#### **gridData.jsx** - Data untuk Tabel
```jsx
// Lines 145, 157: Fetch data files (SALAH - gunakan 127.0.0.1)
const codesRes = await fetch('http://localhost:8000/country-code-and-numeric.json');
const emissionsRes = await fetch('http://localhost:8000/global-complete-data.json');
```

### 10.3. Endpoints Backend yang Tersedia

Berdasarkan file `server/api.R`, endpoint yang tersedia:

1. **`GET /countries`** - Mengembalikan daftar negara
   - Response: `{countries: [{name, code}, ...]}`

2. **`GET /global-complete-data.json`** - Data lengkap emisi global  
   - Response: JSON object dengan data emisi per negara

3. **`GET /statistics`** - Statistik berdasarkan filter
   - Parameters: `country_code`, `start_year`, `end_year`, `year`
   - Response: Statistik per jenis gas (total, co2, ch4, n2o)

4. **`GET /map-data`** - Data untuk visualisasi peta
   - Parameters: `year`, `gas_type`
   - Response: Array data untuk choropleth map

5. **`GET /growth`** - Data pertumbuhan emisi
   - Parameters: `country_code`, `start_year`, `end_year`
   - Response: Data pertumbuhan year-over-year

6. **`GET /country-code-and-numeric.json`** - Mapping kode negara
   - Response: JSON mapping kode negara

### 10.4. Cara Memperbaiki Masalah Koneksi

#### **Opsi 1: Gunakan Environment Variable (Recommended)**

1. **Buat file `.env` di folder frontend:**
```bash
# frontend/.env
REACT_APP_API_BASE=http://127.0.0.1:8000
```

2. **Update semua komponen untuk menggunakan environment variable:**
```jsx
const API_BASE = process.env.REACT_APP_API_BASE || 'http://127.0.0.1:8000';

// Gunakan di semua fetch calls
fetch(`${API_BASE}/countries`)
```

#### **Opsi 2: Ganti Manual Semua localhost ke 127.0.0.1**

**File yang perlu diubah:**
- `src/components/MapScatterHeatChartandOther.jsx`: `localhost:8000` → `127.0.0.1:8000`
- `src/internals/data/gridData.jsx`: `localhost:8000` → `127.0.0.1:8000`  
- `src/components/yoYChartAndGauge.jsx`: Default fallback `localhost:8000` → `127.0.0.1:8000`

#### **Opsi 3: Ubah Backend untuk Accept Localhost**

Di `server/run.R`, ubah host menjadi `0.0.0.0`:
```r
pr$run(port = 8000, host = "0.0.0.0")  # Accept semua interface
```

### 10.5. Testing Koneksi

**Cara test apakah backend berjalan:**
1. Buka browser, akses: `http://127.0.0.1:8000/countries`
2. Seharusnya mengembalikan JSON list negara
3. Jika error, cek apakah server R sudah running di port 8000

**Cara test dari frontend:**
1. Buka Developer Tools (F12) → Network tab  
2. Reload halaman dashboard
3. Lihat apakah semua API calls sukses (status 200)
4. Jika ada yang fail, kemungkinan masalah address/port inconsistency

---

## 11. Alur Data Lengkap: Dari API hingga UI

### 11.1. Saat Halaman Dashboard Dibuka

1. **Dashboard.tsx** merender dan memanggil **MainGrid.jsx**
2. **MainGrid.jsx** menjalankan `useEffect()` yang:
   - Fetch countries dari `/countries` API
   - Fetch statistics dari `/statistics` API dengan parameter default
3. Data disimpan di state menggunakan `setStats()`, `setCountries()`
4. Komponen child menerima data melalui props
5. Setiap komponen visualisasi render berdasarkan data yang diterima

### 11.2. Saat User Mengubah Filter

1. User mengubah negara di **CountryYearFilter**
2. Filter memanggil callback `onCountryChange()` 
3. **MainGrid** menerima perubahan dan update state
4. `useEffect` di MainGrid ter-trigger lagi karena state berubah
5. Fetch data baru dari API dengan parameter baru
6. Semua chart dan visualisasi otomatis update dengan data baru

### 11.3. Saat User Submit Form Simulasi

1. User isi form dan klik "Tambah"
2. Event `handleSubmit()` dijalankan
3. Data form diproses dan statistik dihitung ulang secara lokal
4. State `stats` diupdate dengan data baru
5. Semua visualisasi otomatis update karena state berubah
6. Data asli dari API tidak berubah (hanya lokal)

---

## 12. Tips Debugging untuk Pemula

### 12.1. Debug Front End

1. **Console Browser**: Buka F12 → Console untuk lihat error atau `console.log()`
2. **Network Tab**: Cek apakah API calls berhasil atau gagal
3. **React DevTools**: Extension untuk inspect React components dan state
4. **Material-UI**: Jika styling aneh, cek apakah component MUI diimport dengan benar

### 12.2. Debug Back End

1. **R Console**: Jalankan `print()` atau `cat()` untuk debug
2. **Plumber Logs**: Cek terminal yang menjalankan server untuk error messages
3. **API Testing**: Gunakan browser atau Postman untuk test endpoint langsung
4. **Data Validation**: Pastikan file JSON/CSV ada dan formatnya benar

### 12.3. Debug Komunikasi Front End ↔ Back End

1. **CORS Error**: Pastikan server R mengaktifkan CORS
2. **Port Mismatch**: Pastikan front end memanggil port yang benar (8000)
3. **API Response**: Cek apakah format response sesuai yang diharapkan front end
4. **Parameter**: Pastikan parameter yang dikirim front end sesuai yang diharapkan API

---

## 13. Cara Menambah Fitur Baru

### 13.1. Menambah Endpoint Baru di Back End

```r
#* Contoh endpoint baru
#* @get /new-endpoint
function(param1, param2) {
  # Proses data
  result <- some_processing(param1, param2)
  return(result)
}
```

### 13.2. Menambah Komponen Baru di Front End

```jsx
// NewComponent.jsx
import React, { useState, useEffect } from 'react';

export default function NewComponent() {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    // Fetch data dari API baru
    fetch('http://127.0.0.1:8000/new-endpoint?param1=value1')
      .then(response => response.json())
      .then(data => setData(data));
  }, []);

  return (
    <div>
      {/* Tampilkan data */}
    </div>
  );
}
```

### 13.3. Integrasi ke MainGrid

```jsx
// Di MainGrid.jsx
import NewComponent from './NewComponent';

// Tambahkan di return statement
<Grid item>
  <NewComponent />
</Grid>
```
