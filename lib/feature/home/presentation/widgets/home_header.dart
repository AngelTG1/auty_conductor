import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage_service.dart';

class HomeHeader extends StatefulWidget {
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
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage(); // 🔥 refresca si regresas desde editar imagen
  }

  Future<void> _loadImage() async {
    final img = await SecureStorageService.read('profileImage');

    if (!mounted) return;

    setState(() => profileImage = img);

    print("🔵 HomeHeader cargó imagen: $profileImage");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double avatarRadius = width * 0.047;
    final double iconSize = width * 0.067;
    final double nameFont = width * 0.030;
    final double emailFont = width * 0.025;
    final double spacing = width * 0.02;
    final double splashRadius = width * 0.07;

    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: const Color(0xFFA1A1A1),

          // 👇 Carga la imagen desde Railway (si existe)
          backgroundImage: (profileImage != null && profileImage!.isNotEmpty)
              ? NetworkImage(profileImage!)
              : null,

          child: (profileImage == null || profileImage!.isEmpty)
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: avatarRadius * 1.1,
                )
              : null,
        ),

        SizedBox(width: spacing),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: nameFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                widget.userEmail,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: emailFont, color: Colors.black54),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: widget.onNotifications,
          icon: Icon(Icons.notifications_outlined, size: iconSize),
          splashRadius: splashRadius,
        ),

        IconButton(
          onPressed: widget.onLogout,
          icon: Icon(Icons.logout_rounded, size: iconSize),
          splashRadius: splashRadius,
        ),
      ],
    );
  }
}
