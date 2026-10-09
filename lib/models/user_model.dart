// ignore_for_file: prefer_initializing_formals

/// Abstract class Person yang merepresentasikan konsep Abstraksi dan Polimorfisme dalam OOP
abstract class Person {
  String get namaLengkap;
  String get email;
  String get noHp;

  String getInfoRingkas();
}

/// Kelas User yang mengimplementasikan Encapsulation, Abstraction, dan Inheritance.
class User extends Person {
  @override
  final String namaLengkap;
  final String username;
  final String nim;
  @override
  final String email;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String jenisKelamin; // 'Laki-laki' atau 'Perempuan'
  @override
  final String noHp;
  
  // Password dibungkus secara privat (Encapsulation) untuk keamanan data
  final String _password;

  /// Constructor dengan named parameters
  User({
    required this.namaLengkap,
    required this.username,
    required this.nim,
    required this.email,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.noHp,
    required String password,
  }) : _password = password;

  /// Getter untuk format gabungan Tempat & Tanggal Lahir (contoh: Jakarta, 15 Januari 2002)
  String get tempatTanggalLahir {
    final bulanNama = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final tgl = tanggalLahir.day.toString().padLeft(2, '0');
    final bln = bulanNama[tanggalLahir.month - 1];
    final thn = tanggalLahir.year;
    return '$tempatLahir, $tgl $bln $thn';
  }

  /// Verifikasi kecocokan password untuk kebutuhan autentikasi
  bool verifyPassword(String inputPassword) {
    return _password == inputPassword;
  }

  /// Implementasi metode abstrak dari kelas Person (Polymorphism)
  @override
  String getInfoRingkas() {
    return 'Nama: $namaLengkap | Email: $email';
  }

  @override
  String toString() {
    return 'User(nama: $namaLengkap, username: $username, nim: $nim, email: $email)';
  }
}
