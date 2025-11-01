import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  String? userName;
  String? vehicleBrand;
  String? vehicleColor;
  String? vehicleImageUrl;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? 'Usuario';
    vehicleBrand = prefs.getString('vehicleBrand') ?? 'Chevrolet';
    vehicleColor = prefs.getString('vehicleColor') ?? 'Gris oscuro';
    vehicleImageUrl = prefs.getString('vehicleImageUrl') ??
        'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/auty-pickup.png';

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
