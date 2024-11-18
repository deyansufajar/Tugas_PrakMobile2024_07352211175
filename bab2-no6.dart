import 'dart:async';

// Enum untuk kategori produk
enum KategoriProduk { DataManagement, NetworkAutomation }

// Kelas ProdukDigital dengan metode terapkanDiskon
class ProdukDigital {
  final String namaProduk;
  final KategoriProduk kategori;
  double harga;
  int jumlahTerjual = 0;

  ProdukDigital({
    required this.namaProduk,
    required this.kategori,
    required double harga,
  }) : harga = (kategori == KategoriProduk.NetworkAutomation && harga < 200000)
            ? throw Exception("Harga NetworkAutomation minimal 200.000.")
            : harga;

  // Metode untuk menerapkan diskon 15% jika memenuhi syarat
  void terapkanDiskon() {
    if (kategori == KategoriProduk.NetworkAutomation && jumlahTerjual > 50) {
      final hargaDiskon = harga * 0.85;
      if (hargaDiskon >= 200000) {
        harga = hargaDiskon;
        print("Diskon 15% diterapkan. Harga baru: Rp$harga");
      }
    }
  }

  void tambahPenjualan(int jumlah) {
    jumlahTerjual += jumlah;
    terapkanDiskon();
  }
}

// Kelas abstrak Karyawan dengan metode bekerja
abstract class Karyawan {
  final String nama;
  final int umur;
  final String peran;

  Karyawan({
    required this.nama,
    required this.umur,
    required this.peran,
  });

  void bekerja();
}

// Subclass KaryawanTetap dan KaryawanKontrak
class KaryawanTetap extends Karyawan {
  KaryawanTetap({required String nama, required int umur, required String peran})
      : super(nama: nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print("$nama adalah karyawan tetap yang bekerja selama hari kerja reguler.");
  }
}

class KaryawanKontrak extends Karyawan {
  final int durasiProyek;

  KaryawanKontrak(
      {required String nama, required int umur, required String peran, required this.durasiProyek})
      : super(nama: nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print("$nama adalah karyawan kontrak yang bekerja pada proyek dengan durasi $durasiProyek hari.");
  }
}

// Mixin untuk mengatur produktivitas
mixin Kinerja {
  int _produktivitas = 0;
  DateTime _lastUpdate = DateTime.now();

  int get produktivitas => _produktivitas;

  void updateProduktivitas(int nilaiBaru) {
    final now = DateTime.now();
    if (now.difference(_lastUpdate).inDays < 30) {
      print("Produktivitas hanya bisa diperbarui setiap 30 hari.");
      return;
    }

    if (nilaiBaru < 0 || nilaiBaru > 100) {
      print("Produktivitas harus di antara 0 dan 100.");
      return;
    }

    _produktivitas = nilaiBaru;
    _lastUpdate = now;
    print("Produktivitas diperbarui menjadi $_produktivitas");
  }
}

// Implementasi Enum FaseProyek untuk manajemen fase proyek
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  List<Karyawan> timProyek = [];
  DateTime? tanggalMulai;

  void tambahKaryawan(Karyawan karyawan) {
    timProyek.add(karyawan);
    print("${karyawan.nama} ditambahkan ke tim proyek.");
  }

  // Transisi fase proyek
  void pindahKePengembangan() {
    if (fase == FaseProyek.Perencanaan && timProyek.length >= 5) {
      fase = FaseProyek.Pengembangan;
      tanggalMulai = DateTime.now();
      print("Proyek beralih ke fase Pengembangan.");
    } else {
      print("Syarat untuk beralih ke Pengembangan belum terpenuhi.");
    }
  }

  void pindahKeEvaluasi() {
    if (fase == FaseProyek.Pengembangan && tanggalMulai != null) {
      if (DateTime.now().difference(tanggalMulai!).inDays > 45) {
        fase = FaseProyek.Evaluasi;
        print("Proyek beralih ke fase Evaluasi.");
      } else {
        print("Proyek harus berjalan lebih dari 45 hari untuk beralih ke Evaluasi.");
      }
    } else {
      print("Syarat untuk beralih ke Evaluasi belum terpenuhi.");
    }
  }
}

// Kelas Perusahaan untuk mengatur karyawan aktif dan non-aktif
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  static const int batasMaksKaryawan = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < batasMaksKaryawan) {
      karyawanAktif.add(karyawan);
      print("Karyawan ${karyawan.nama} ditambahkan sebagai karyawan aktif.");
    } else {
      print("Batas maksimal karyawan aktif tercapai.");
    }
  }

  void karyawanResign(Karyawan karyawan) {
    if (karyawanAktif.remove(karyawan)) {
      karyawanNonAktif.add(karyawan);
      print("Karyawan ${karyawan.nama} kini menjadi non-aktif.");
    } else {
      print("Karyawan tidak ditemukan dalam daftar aktif.");
    }
  }
}

// Fungsi utama
void main() {
  // Contoh ProdukDigital
  try {
    var produk1 = ProdukDigital(namaProduk: "Data Analysis Tool", kategori: KategoriProduk.DataManagement, harga: 150000);
    var produk2 = ProdukDigital(namaProduk: "Network Optimizer", kategori: KategoriProduk.NetworkAutomation, harga: 250000);

    produk2.tambahPenjualan(51);
  } catch (e) {
    print("Error: $e");
  }

  // Karyawan
  var karyawanTetap = KaryawanTetap(nama: "Alice", umur: 30, peran: "Manager");
  var karyawanKontrak = KaryawanKontrak(nama: "Bob", umur: 25, peran: "Developer", durasiProyek: 60);

  // Perusahaan
  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawanTetap);
  perusahaan.tambahKaryawan(karyawanKontrak);

  // Manajemen Fase Proyek
  var proyek = Proyek();
  proyek.tambahKaryawan(karyawanTetap);
  proyek.tambahKaryawan(karyawanKontrak);

  proyek.pindahKePengembangan();
  proyek.pindahKeEvaluasi(); // Menunggu 45 hari untuk pindah ke Evaluasi

  // Resign karyawan
  perusahaan.karyawanResign(karyawanKontrak);
}