import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _namaLengkapController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedTanggalLahir;
  String _selectedJenisKelamin = 'Laki-laki';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _usernameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggalLahir() async {
    final now = DateTime.now();
    final initialDate = _selectedTanggalLahir ?? DateTime(2003, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedTanggalLahir = pickedDate;
        final bulanNama = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        _tanggalLahirController.text =
            '${pickedDate.day.toString().padLeft(2, '0')} ${bulanNama[pickedDate.month - 1]} ${pickedDate.year}';
      });
    }
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan pilih Tanggal Lahir terlebih dahulu!'),
          backgroundColor: const Color(0xFFF43F5E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      final newUser = User(
        namaLengkap: _namaLengkapController.text.trim(),
        username: _usernameController.text.trim(),
        nim: _nimController.text.trim(),
        email: _emailController.text.trim(),
        tempatLahir: _tempatLahirController.text.trim(),
        tanggalLahir: _selectedTanggalLahir!,
        jenisKelamin: _selectedJenisKelamin,
        noHp: _noHpController.text.trim(),
        password: _passwordController.text,
      );

      final errorMessage = _authService.registerUser(newUser);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: const Color(0xFFF43F5E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Registrasi ${newUser.namaLengkap} berhasil! Silakan login.'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );

        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        title: const Text(
          'Daftar Akun Baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Lengkapi Data Diri',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pastikan seluruh informasi terisi dengan benar.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 24),

                  // Glassmorphic Card Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 32,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Nama Lengkap
                              _buildDarkTextField(
                                controller: _namaLengkapController,
                                label: 'Nama Lengkap',
                                hint: 'Contoh: Ahmad Fauzan',
                                icon: Icons.badge_outlined,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama Lengkap wajib diisi!';
                                  }
                                  if (value.trim().length < 3) {
                                    return 'Nama minimal 3 karakter!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 2. Username
                              _buildDarkTextField(
                                controller: _usernameController,
                                label: 'Username',
                                hint: 'Contoh: fauzan23',
                                icon: Icons.alternate_email_rounded,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Username wajib diisi!';
                                  }
                                  if (value.contains(' ')) {
                                    return 'Username tidak boleh mengandung spasi!';
                                  }
                                  if (value.length < 4) {
                                    return 'Username minimal 4 karakter!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 3. NIM
                              _buildDarkTextField(
                                controller: _nimController,
                                label: 'NIM (Nomor Induk Mahasiswa)',
                                hint: 'Contoh: 2110512001',
                                icon: Icons.school_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'NIM wajib diisi!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 4. Email
                              _buildDarkTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Contoh: user@domain.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email wajib diisi!';
                                  }
                                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return 'Format email tidak valid!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 5. Tempat Lahir
                              _buildDarkTextField(
                                controller: _tempatLahirController,
                                label: 'Tempat Lahir',
                                hint: 'Contoh: Jakarta',
                                icon: Icons.location_city_outlined,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Tempat Lahir wajib diisi!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 6. Tanggal Lahir (Picker)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal Lahir',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _tanggalLahirController,
                                    readOnly: true,
                                    onTap: _pickTanggalLahir,
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Pilih Tanggal Lahir',
                                      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                      prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF6366F1), size: 20),
                                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
                                      filled: true,
                                      fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (_selectedTanggalLahir == null) {
                                        return 'Tanggal Lahir wajib dipilih!';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // 7. Jenis Kelamin Selector
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jenis Kelamin',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => setState(() => _selectedJenisKelamin = 'Laki-laki'),
                                          borderRadius: BorderRadius.circular(16),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            decoration: BoxDecoration(
                                              color: _selectedJenisKelamin == 'Laki-laki'
                                                  ? const Color(0xFF6366F1).withValues(alpha: 0.25)
                                                  : const Color(0xFF1E293B).withValues(alpha: 0.6),
                                              border: Border.all(
                                                color: _selectedJenisKelamin == 'Laki-laki'
                                                    ? const Color(0xFF6366F1)
                                                    : Colors.white.withValues(alpha: 0.08),
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.male,
                                                  color: _selectedJenisKelamin == 'Laki-laki'
                                                      ? const Color(0xFF818CF8)
                                                      : Colors.grey.shade400,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Laki-laki',
                                                  style: TextStyle(
                                                    color: _selectedJenisKelamin == 'Laki-laki'
                                                        ? Colors.white
                                                        : Colors.grey.shade400,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => setState(() => _selectedJenisKelamin = 'Perempuan'),
                                          borderRadius: BorderRadius.circular(16),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            decoration: BoxDecoration(
                                              color: _selectedJenisKelamin == 'Perempuan'
                                                  ? const Color(0xFFEC4899).withValues(alpha: 0.25)
                                                  : const Color(0xFF1E293B).withValues(alpha: 0.6),
                                              border: Border.all(
                                                color: _selectedJenisKelamin == 'Perempuan'
                                                    ? const Color(0xFFEC4899)
                                                    : Colors.white.withValues(alpha: 0.08),
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.female,
                                                  color: _selectedJenisKelamin == 'Perempuan'
                                                      ? const Color(0xFFF472B6)
                                                      : Colors.grey.shade400,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Perempuan',
                                                  style: TextStyle(
                                                    color: _selectedJenisKelamin == 'Perempuan'
                                                        ? Colors.white
                                                        : Colors.grey.shade400,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // 8. No HP
                              _buildDarkTextField(
                                controller: _noHpController,
                                label: 'Nomor Handphone',
                                hint: 'Contoh: 081234567890',
                                icon: Icons.phone_android_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nomor HP wajib diisi!';
                                  }
                                  if (value.trim().length < 9) {
                                    return 'Nomor HP minimal 9 digit!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 9. Password
                              _buildDarkTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Minimal 6 karakter',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password wajib diisi!';
                                  }
                                  if (value.length < 6) {
                                    return 'Password minimal 6 karakter!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // 10. Confirm Password
                              _buildDarkTextField(
                                controller: _confirmPasswordController,
                                label: 'Konfirmasi Password',
                                hint: 'Ulangi kata sandi',
                                icon: Icons.lock_reset_rounded,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Konfirmasi Password wajib diisi!';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Password konfirmasi tidak cocok!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 28),

                              // Submit Button
                              Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'DAFTAR AKUN SEKARANG',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Back to Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah memiliki akun? ',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
