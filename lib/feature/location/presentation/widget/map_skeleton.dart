import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.white)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: 200,
                height: 20,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                width: 260,
                height: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
