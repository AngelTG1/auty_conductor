import 'package:auty_conductor/feature/profile/presentation/pages/data_perfil_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
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
  String? profileImageUrl;

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
    await Future.delayed(const Duration(milliseconds: 300));

    final name = await SecureStorageService.read('userName');
    final email = await SecureStorageService.read('userEmail');
    final img = await SecureStorageService.read('profileImage');

    if (!mounted) return;

    safeSetState(() {
      userName = name ?? 'Conductor';
      userEmail = email ?? 'Correo no disponible';
      profileImageUrl = img;
      loading = false;
    });
  }

  Future<void> _confirmLogout() async {
    final width = MediaQuery.of(context).size.width;
    final double dialogFont = width * 0.030;
    final double buttonFont = width * 0.030;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '¿Cerrar sesión?',
            style: TextStyle(fontSize: dialogFont, fontWeight: FontWeight.bold),
          ),
          content: Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(fontSize: dialogFont * 0.9),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey, fontSize: buttonFont),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF235EE8),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: buttonFont),
              ),
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
    final width = MediaQuery.of(context).size.width;

    final double titleFont = width * 0.045;
    final double avatarRadius = width * 0.060;
    final double avatarIcon = width * 0.056;
    final double nameFont = width * 0.035;
    final double emailFont = width * 0.028;
    final double cardPadding = width * 0.045;
    final double spacing = width * 0.035;
    final double optionIcon = width * 0.065;
    final double optionFont = width * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: loading
              ? const _ProfileSkeleton()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Configuración de perfil",
                      style: TextStyle(
                        fontSize: titleFont,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing * 1.5),

                    // --------------------------------------------------------------
                    // 🔵 FOTO DEL USUARIO (sin modificar UI)
                    // --------------------------------------------------------------
                    Container(
                      padding: EdgeInsets.all(cardPadding),
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
                          CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: const Color(0xFF235EE8),

                            backgroundImage:
                                (profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty)
                                ? NetworkImage(profileImageUrl!)
                                : null,

                            child:
                                (profileImageUrl == null ||
                                    profileImageUrl!.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: avatarIcon,
                                  )
                                : null,
                          ),

                          SizedBox(width: spacing),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName ?? '',
                                  style: TextStyle(
                                    fontSize: nameFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  userEmail ?? '',
                                  style: TextStyle(
                                    fontSize: emailFont,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --------------------------------------------------------------
                    // 🔴 CERRAR SESIÓN
                    // --------------------------------------------------------------
                    GestureDetector(
                      onTap: _confirmLogout,
                      child: Container(
                        padding: EdgeInsets.all(cardPadding),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cerrar sesión",
                              style: TextStyle(
                                fontSize: optionFont,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.blue,
                              size: optionIcon * 0.8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: spacing * 2),

                    // --------------------------------------------------------------
                    // 🔹 Opciones
                    // --------------------------------------------------------------
                    _buildOptionCard(
                      Icons.person_outline_rounded,
                      "Perfil",
                      Colors.black87,
                      optionIcon,
                      optionFont,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DataPerfilPage(),
                          ),
                        ).then((_) {
                          // recargar al volver
                          _loadProfile();
                        });
                      },
                    ),
                    SizedBox(height: spacing),
                    _buildOptionCard(
                      Icons.lock_outline,
                      "Seguridad de la cuenta",
                      Colors.black87,
                      optionIcon,
                      optionFont,
                    ),
                    SizedBox(height: spacing),
                    _buildOptionCard(
                      Icons.delete_outlined,
                      "Eliminar cuenta",
                      Colors.black,
                      optionIcon,
                      optionFont,
                    ),
                    SizedBox(height: spacing),
                    _buildOptionCard(
                      Icons.privacy_tip_outlined,
                      "Política de privacidad",
                      Colors.black,
                      optionIcon,
                      optionFont,
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
    Color iconColor,
    double iconSize,
    double textFont, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(iconSize * 0.6),
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
                Icon(icon, size: iconSize, color: iconColor),
                SizedBox(width: iconSize * 0.5),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: textFont,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: iconSize * 0.55,
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
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            height: width * 0.05,
            width: width * 0.45,
            color: Colors.white,
          ),
          for (int i = 0; i < 4; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: width * 0.18,
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
