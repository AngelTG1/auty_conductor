import 'package:auty_conductor/feature/profile/presentation/pages/data_perfil_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart'; // 👈 shimmer agregado
import 'package:auty_conductor/core/services/secure_storage_service.dart';
import 'package:auty_conductor/core/utils/safe_async_state.dart';
import 'package:auty_conductor/core/router/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SafeAsyncState {
  bool loading = true;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userLicense;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!loading) return; // ✅ evita recargar
    await Future.delayed(const Duration(seconds: 2));
    final name = await SecureStorageService.read('userName');
    final email = await SecureStorageService.read('userEmail');

    if (!mounted) return;
    safeSetState(() {
      userName = name ?? 'Conductor';
      userEmail = email ?? 'Correo no disponible';
      loading = false;
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Cerrar sesión?'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF235EE8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await SecureStorageService.clear();
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: loading
              ? const _ProfileSkeleton() // 👈 loading shimmer aquí
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Configuración de perfil",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Perfil card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFF235EE8),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  userEmail ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Botón cerrar sesión
                    GestureDetector(
                      onTap: _confirmLogout,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 0.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cerrar sesión",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.logout_rounded, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildOptionCard(
                      Icons.person_outline_rounded,
                      "Perfil",
                      Colors.black87,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DataPerfilPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildOptionCard(
                      Icons.lock_outline,
                      "Seguridad de la cuenta",
                      Colors.black87,
                    ),
                    const SizedBox(height: 10),
                    _buildOptionCard(
                      Icons.delete_outlined,
                      "Eliminar cuenta",
                      Colors.black,
                    ),
                    const SizedBox(height: 10),
                    _buildOptionCard(
                      Icons.privacy_tip_outlined,
                      "Política de privacidad",
                      Colors.black,
                      onTap: () {
                        context.push(AppRoutes.privacyWeb);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    IconData icon,
    String text,
    Color iconColor, {
    VoidCallback? onTap, // 👈 nuevo parámetro opcional
  }) {
    return GestureDetector(
      onTap: onTap, // 👈 ahora responde al toque
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 25, color: iconColor),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            height: 20,
            width: 180,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < 4; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }
}
