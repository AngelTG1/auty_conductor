import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final VoidCallback onNotifications;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 🔹 Valores responsivos basados en el ancho
    final double avatarRadius = width * 0.047; // ~17–20 px
    final double iconSize = width * 0.067; 
    final double nameFont = width * 0.030; 
    final double emailFont = width * 0.025; 
    final double spacing = width * 0.02; 
    final double splashRadius = width * 0.07; 

    return Row(
      children: [
        // 🟣 Avatar
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: const Color(0xFFA1A1A1),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: avatarRadius * 1.1,
          ),
        ),

        SizedBox(width: spacing),

        // 🟦 Nombre + correo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: nameFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                userEmail,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: emailFont, color: Colors.black54),
              ),
            ],
          ),
        ),

        // 🔔 Notificaciones
        IconButton(
          onPressed: onNotifications,
          icon: Icon(Icons.notifications_outlined, size: iconSize),
          splashRadius: splashRadius,
        ),

        // 🔓 Logout
        IconButton(
          onPressed: onLogout,
          icon: Icon(Icons.logout_rounded, size: iconSize),
          splashRadius: splashRadius,
        ),
      ],
    );
  }
}
