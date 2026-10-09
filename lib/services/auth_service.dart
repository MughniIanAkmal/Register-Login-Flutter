import '../models/user_model.dart';

/// Kontrak abstraksi (Interface / Abstract Class) untuk operasi autentikasi
abstract class AuthRepository {
  String? registerUser(User user);
  User? loginUser(String usernameOrEmail, String password);
  void logout();
  User? getCurrentUser();
  List<User> getAllUsers();
}

/// Implementasi Layanan Autentikasi dengan Konsep OOP Singleton Pattern
/// Menyimpan data pengguna dalam memori dan mengelola sesi pengguna yang sedang login.
class AuthService implements AuthRepository {
  // Private static instance untuk Singleton
  static final AuthService _instance = AuthService._internal();

  // Factory constructor mengembalikan instance tunggal
  factory AuthService() {
    return _instance;
  }

  // Private constructor
  AuthService._internal();

  // Koleksi objek User (Encapsulation pada data repository)
  final List<User> _userList = [];

  // Menyimpan sesi user yang saat ini sedang login
  User? _currentUser;

  @override
  User? getCurrentUser() {
    return _currentUser;
  }

  @override
  List<User> getAllUsers() {
    return List.unmodifiable(_userList);
  }

  /// Mendaftarkan pengguna baru.
  /// Mengembalikan String error jika gagal (misal: username/email sudah terdaftar), atau null jika sukses.
  @override
  String? registerUser(User user) {
    // Validasi apakah username sudah digunakan
    final isUsernameTaken = _userList.any(
      (u) => u.username.toLowerCase() == user.username.toLowerCase(),
    );
    if (isUsernameTaken) {
      return 'Username sudah digunakan, silakan gunakan username lain!';
    }

    // Validasi apakah email sudah digunakan
    final isEmailTaken = _userList.any(
      (u) => u.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (isEmailTaken) {
      return 'Email sudah terdaftar, silakan gunakan email lain!';
    }

    // Validasi apakah NIM sudah digunakan
    final isNimTaken = _userList.any(
      (u) => u.nim == user.nim,
    );
    if (isNimTaken) {
      return 'NIM sudah terdaftar dalam sistem!';
    }

    // Simpan user ke dalam list
    _userList.add(user);
    return null; // Sukses tanpa pesan error
  }

  /// Memverifikasi autentikasi login berdasarkan Username atau Email dan Password.
  @override
  User? loginUser(String usernameOrEmail, String password) {
    try {
      final user = _userList.firstWhere(
        (u) =>
            (u.username.toLowerCase() == usernameOrEmail.toLowerCase() ||
             u.email.toLowerCase() == usernameOrEmail.toLowerCase()) &&
            u.verifyPassword(password),
      );
      _currentUser = user;
      return user;
    } catch (e) {
      // User tidak ditemukan atau password salah
      return null;
    }
  }

  /// Keluar dari sesi akun saat ini
  @override
  void logout() {
    _currentUser = null;
  }
}
