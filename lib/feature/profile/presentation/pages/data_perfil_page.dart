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
    await Future.delayed(const Duration(milliseconds: 400));
    final name = await SecureStorageService.read('userName');
    final email = await SecureStorageService.read('userEmail');
    final phone = await SecureStorageService.read('userPhone');
    final license = await SecureStorageService.read('licenseNumber');

    if (!mounted) return;
    setState(() {
      userName = name ?? 'No disponible';
      userEmail = email ?? 'No disponible';
      userPhone = (phone == null || phone.isEmpty) ? 'Sin verificar' : phone;
      userLicense = license ?? 'No disponible';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 🔹 fuentes responsivas
    final double titleFont = width * 0.045; // 17–20
    final double tileLabelFont = width * 0.032; // 12–14
    final double tileValueFont = width * 0.038; // 14–16
    final double iconSize = width * 0.065; // 22–28
    final double tilePadding = width * 0.04; // 14–18
    final double spacing = width * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Datos del perfil",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: titleFont,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    label: "Nombre completo",
                    value: userName,
                    iconSize: iconSize,
                    labelFont: tileLabelFont,
                    valueFont: tileValueFont,
                    padding: tilePadding,
                  ),
                  SizedBox(height: spacing),

                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    label: "Correo electrónico",
                    value: userEmail,
                    iconSize: iconSize,
                    labelFont: tileLabelFont,
                    valueFont: tileValueFont,
                    padding: tilePadding,
                  ),
                  SizedBox(height: spacing),

                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    label: "Teléfono",
                    value: userPhone,
                    iconSize: iconSize,
                    labelFont: tileLabelFont,
                    valueFont: tileValueFont,
                    padding: tilePadding,
                  ),
                  SizedBox(height: spacing),

                  _buildInfoTile(
                    icon: Icons.credit_card_outlined,
                    label: "Licencia de conducir",
                    value: userLicense,
                    iconSize: iconSize,
                    labelFont: tileLabelFont,
                    valueFont: tileValueFont,
                    padding: tilePadding,
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
    required double iconSize,
    required double labelFont,
    required double valueFont,
    required double padding,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
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
          Icon(icon, color: const Color(0xFF235EE8), size: iconSize),
          SizedBox(width: padding),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFont,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  value ?? 'No disponible',
                  style: TextStyle(
                    fontSize: valueFont,
                    fontWeight: FontWeight.w600,
                    color: value == 'Sin verificar'
                        ? Colors.redAccent
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
