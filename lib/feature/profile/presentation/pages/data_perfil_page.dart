import 'package:flutter/material.dart';
import 'package:auty_conductor/core/services/secure_storage_service.dart';

class DataPerfilPage extends StatefulWidget {
  const DataPerfilPage({super.key});

  @override
  State<DataPerfilPage> createState() => _DataPerfilPageState();
}

class _DataPerfilPageState extends State<DataPerfilPage> {
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userLicense;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await Future.delayed(const Duration(milliseconds: 400)); // pequeño delay
    final name = await SecureStorageService.read('userName');
    final email = await SecureStorageService.read('userEmail');
    final phone = await SecureStorageService.read('userPhone');
    final license = await SecureStorageService.read('userLicense');

    if (!mounted) return;
    setState(() {
      userName = name ?? 'No disponible';
      userEmail = email ?? 'No disponible';
      // 👇 si no hay teléfono, muestra “Sin verificar”
      if (phone == null || phone.isEmpty) {
        userPhone = 'Sin verificar';
      } else {
        userPhone = phone;
      }
      userLicense = license ?? 'No disponible';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Datos del perfil",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    label: "Nombre completo",
                    value: userName,
                  ),
                  const SizedBox(height: 14),
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    label: "Correo electrónico",
                    value: userEmail,
                  ),
                  const SizedBox(height: 14),
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    label: "Teléfono",
                    value: userPhone,
                  ),
                  const SizedBox(height: 14),
                  _buildInfoTile(
                    icon: Icons.credit_card_outlined,
                    label: "Licencia de conducir",
                    value: userLicense,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF235EE8), size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'No disponible',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: value == 'Sin verificar'
                        ? Colors
                              .redAccent // 🔴 destaca si no está verificado
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
