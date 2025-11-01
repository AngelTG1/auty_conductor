import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Icon(Icons.menu, color: Colors.black),
      ],
    );
  }
}
