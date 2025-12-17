import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class GlowingMicButton extends StatelessWidget {
  final VoidCallback onTap;

  const GlowingMicButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowCount: 3,
      glowRadiusFactor: 0.3,
      animate: true,
      glowColor: Colors.orange.withAlpha((255 * 0.5).round()),
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              center: Alignment.center,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.orange, blurRadius: 35, spreadRadius: 5),
            ],
          ),
          child: Icon(Icons.mic_none_sharp, size: 35),
        ),
      ),
    );
  }
}
