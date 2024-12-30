# Tugas Kelompok Proyek Akhir Semester Pemrograman Berbasis Platform

<br>

# 🏢 Our Team

| NPM | Nama | Username |
| -- | -- | -- |
| 2306165742 | Bryan Mitch | brjaeger
| 2306231422 | Muhammad Farhan Ramadhan | vmuhfarhan
| 2306221352 | Faiz Akram Pribadi | FaizAP412
| 2306245453 | Indah Cahya Puspitahati | indahcahyaaa
| 2306275973 | Daniel Angger Dewandaru | DanielAngger

<br>

# 🥐 BiteTracker 🥐

### 🔗 [Visit Our Web](https://faiz-akram-bitetracker.pbp.cs.ui.ac.id/)
### 🔗 [Download Our App](https://install.appcenter.ms/orgs/bite-tracker/apps/bite-tracker/distribution_groups/public/releases/4)


**BiteTracker** adalah platform pencarian produk makanan berbasis lokasi yang berfokus di kota **Depok**. Aplikasi ini dirancang untuk memudahkan pengguna dalam menemukan makanan dan toko sesuai dengan preferensi diet dan gaya hidup mereka. Dengan fitur pencarian yang terperinci dan pelacakan asupan kalori, pengguna dapat dengan mudah menemukan makanan yang sesuai kebutuhan serta memantau pola makan mereka.

Setiap produk makanan dilengkapi dengan tag deskriptif seperti jumlah kalori (rendah/tinggi), jenis makanan (Vegan/Non-Vegan), serta kandungan gula (Low sugar/High sugar), sehingga pengguna dapat menyesuaikan pilihan makanan sesuai dengan preferensi kesehatan dan gaya hidup mereka. 

Aplikasi BiteTracker memungkinkan seorang pengguna yang memiliki role **admin** untuk menambahkan produk-produk makanan ringan yang bermanfaat untuk mempromosikan produk-produk mereka. Sementara untuk role **customer**, mereka bisa melihat-lihat produk yang sedang dijual dari berbagai lokasi, memungkinkan mereka untuk bisa mengetahui lokasi toko dan membelinya disana.

## 📁 Moduls

### 1. ✍️ EditBites

Pembuat : **Muhammad Farhan Ramadhan**

Pada modul **EditBites**, pengguna dengan role Admin bisa menambahkan, menyunting, dan menghapus produk yang ingin ditampilkan di website. Adapun identitas data yang akan ditampilkan di setiap product antara lain nama produk, harga, deskripsi produk, jumlah kalori, tag kalori (rendah/tinggi), tag vegan (vegan/non), tag gula (rendah/tinggi), dan foto produk. 

| Role | Deskripsi |
| -- | -- |
| Admin | Admin dapat menambahkan, menyunting, dan menghapus produk yang ingin ditampilkan di website |

### 2. 🍽️ MyBites

Pembuat : **Daniel Angger Dewandaru**

Pada modul **MyBites** (seperti wishlist), pengguna bisa menambahkan semacam produk favorit yang bisa menjadi bahan pertimbangan mereka bila ingin pergi membelinya pada lokasi toko yang tertera. Pada modul MyBites, pengguna bisa menambahkan, mengurangi, ataupun mengatur MyBites sesuai keinginan mereka.

| Role | Deskripsi |
| -- | -- |
| Member | pengguna bisa menambahkan, mengurangi, ataupun mengatur MyBites |

### 3. 📝 ArtiBites

Pembuat : **Bryan Mitch**

Pada modul **ArtiBites**, berfungsi sebagai pusat, atau sumber informasi bagi pengguna untuk membaca konten-konten yang relevan dengan produk, kesehatan, dan gaya hidup. Article-article yang tersedia dapat memberikan tips, hingga berita terbaru terkait produk, atau topik tertentu seperti pola makan sehat, dan gaya hidup sehat.

| Role | Deskripsi |
| -- | -- |
| Member | Pengguna bisa membaca artikel yang dibuat oleh Admin |
| Admin | Admin dapat membuat, mengedit, dan menghapus artikel yang dibuat |

### 4. 🗣️ ShareBites

Pembuat : **Indah Cahya Puspitahati**

Pada modul **ShareBites**, pengguna dapat berbagi rekomendasi snack sehat dengan komunitas BiteTracker. Pengguna dapat membuat postingan untuk berbagi snack favorit mereka dengan mengunggah gambar, menulis deskripsi, dan menandai produk dengan informasi nutrisi yang relevan (misalnya, kalori, Vegan/Non-Vegan, rendah/tinggi gula). 

| Role | Deskripsi |
| -- | -- |
| Member | pengguna dapat membuat postingan yang berisi deskripsi, gambar produk, tag produk (Low/High Kalori, Vegan/Non-Vegan, Low/High Sugar) |

### 5. 📊 TrackerBites

Pembuat : **Faiz Akram Pribadi**

Pada modul **TrackerBites**, user dapat melakukan pencatatan terhadap kalori yang didapatkan dari makanan atau minuman yang dikonsumsi. Data yang diinput oleh User akan disimpan dan diolah, kemudian ditampilkan dalam bentuk grafik yang memudahkan User untuk melihat pola konsumsi kalori mereka secara visual. Grafik ini dapat menampilkan tren harian, mingguan, atau bulanan, sehingga memudahkan User untuk memantau progres dan menentukan apakah mereka sudah mencapai target kalori harian.

| Role | Deskripsi |
| -- | -- |
| Member | Mencatat dan memodifikasi catatan konsumsi kalori sehari-hari |

## 🧑‍💻 Role User

Berikut merupakan role yang ada dalam program ini:

| Role | Deskripsi |
| -- | -- |
| Member | -MyBites<br>-ArtiBites<br>-ShareBites<br>-TrackerBites |
| Admin | -EditBites<br>-ArtiBites

Untuk penjelasan lengkap terkait deskripsi dari setiap Role 


## 💾 Dataset

Sumber dataset ada disini [Dataset](/assets/Dataset%20Snack%20Depok.csv)

Dataset ini merupakan hasil informasi dari 100 produk cemilan-ringan(snack) yang dikumpulkan dari berbagai sumber oleh kelompok kami.

## Alur Pengintegrasian Proyek Tengah Semester dan Proyek Akhir Semester

1. Integrasi aplikasi mobile dan web service dapat dilakukan dengan car melakukan pengambilan data berformat
JSON atau Javascript Object Notation di aplikasi mobile pada web service dengan menggunakan ur untuk deploy Proyek Tengah Semester.

2. Proses fetch dapat dilakukan dengan menggunakan HTTP dari dependensi pbp_django_auth di dalam file Dart, lalu mengambilnya menggunakan get dengan tipe application/json.

3. Menambahkan app/authentication pada Django agar memungkinkan login pada Flutter.

3. Selanjutnya, data yang telah diambil tadi dapat di-decode menggunakan jsonDecode() yang nantinya akan di-convert melalui model yang telah dibuat dan ditampilkan secara asinkronus menggunakan widget
FutureBuilder

4. Data - data JSON tadi dapat digunakan secara CRUD pada kedua media secara asinkronus
