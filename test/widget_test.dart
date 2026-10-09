import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/main.dart';
import 'package:auth_app/models/user_model.dart';
import 'package:auth_app/services/auth_service.dart';

void main() {
  setUp(() {
    // Pastikan user Budi Santoso selalu terdaftar sebelum setiap pengujian
    final authService = AuthService();
    authService.registerUser(
      User(
        namaLengkap: 'Budi Santoso',
        username: 'budisan',
        nim: '2210511045',
        email: 'budi.santoso@kampus.ac.id',
        tempatLahir: 'Jakarta',
        tanggalLahir: DateTime(2002, 5, 20),
        jenisKelamin: 'Laki-laki',
        noHp: '081234567890',
        password: 'password123',
      ),
    );
  });

  group('Pengujian Konsep OOP & AuthService', () {
    final authService = AuthService();

    test('OOP User Model Encapsulation & Polymorphism Test', () {
      final user = User(
        namaLengkap: 'Dewi Sartika',
        username: 'dewisartika',
        nim: '2110512055',
        email: 'dewi@kampus.ac.id',
        tempatLahir: 'Bandung',
        tanggalLahir: DateTime(2001, 12, 4),
        jenisKelamin: 'Perempuan',
        noHp: '081298765432',
        password: 'rahasia123',
      );

      // Verifikasi Encapsulation & Getters
      expect(user.namaLengkap, equals('Dewi Sartika'));
      expect(user.email, equals('dewi@kampus.ac.id'));
      expect(user.tempatTanggalLahir, equals('Bandung, 04 Desember 2001'));
      
      // Verifikasi Verifikasi Password
      expect(user.verifyPassword('rahasia123'), isTrue);
      expect(user.verifyPassword('salah'), isFalse);

      // Verifikasi Polimorfisme Person
      expect(user.getInfoRingkas(), contains('Dewi Sartika'));
      expect(user.getInfoRingkas(), contains('dewi@kampus.ac.id'));
    });

    test('AuthService Register and Login flow', () {
      final testUser = User(
        namaLengkap: 'Rian Pratama',
        username: 'rianp',
        nim: '2210511088',
        email: 'rian@kampus.ac.id',
        tempatLahir: 'Surabaya',
        tanggalLahir: DateTime(2002, 3, 10),
        jenisKelamin: 'Laki-laki',
        noHp: '085712345678',
        password: 'securePassword',
      );

      // Registrasi
      final regResult = authService.registerUser(testUser);
      expect(regResult, isNull); // sukses tanpa error

      // Login dengan kredensial benar
      final loggedInUser = authService.loginUser('rianp', 'securePassword');
      expect(loggedInUser, isNotNull);
      expect(loggedInUser!.namaLengkap, equals('Rian Pratama'));
      expect(loggedInUser.email, equals('rian@kampus.ac.id'));

      // Logout
      authService.logout();
      expect(authService.getCurrentUser(), isNull);
    });
  });

  group('Pengujian Widget UI', () {
    testWidgets('Tampilan Login Muncul dan Bisa Navigasi', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Cek elemen Login Screen
      expect(find.text('Selamat Datang Kembali'), findsOneWidget);
      expect(find.text('Username atau Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Masuk Sekarang'), findsOneWidget);
      expect(find.text('Daftar Sekarang'), findsOneWidget);

      // Tap 'Daftar Sekarang' untuk navigasi ke Register
      await tester.tap(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();

      // Cek halaman Registrasi
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('NIM (Nomor Induk Mahasiswa)'), findsOneWidget);
      expect(find.text('Jenis Kelamin'), findsOneWidget);
      expect(find.text('Nomor Handphone (HP)'), findsOneWidget);
    });

    testWidgets('Login berhasil dengan sample user dan masuk ke Home', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Isi Username 'budisan' dan Password 'password123'
      await tester.enterText(find.byType(TextFormField).at(0), 'budisan');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pumpAndSettle();

      // Tekan tombol Masuk
      await tester.tap(find.text('Masuk Sekarang'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Harus masuk ke HomeScreen dan menampilkan Nama Lengkap serta Email
      expect(find.text('Beranda Pengguna'), findsOneWidget);
      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.text('budi.santoso@kampus.ac.id'), findsOneWidget);
    });
  });
}
