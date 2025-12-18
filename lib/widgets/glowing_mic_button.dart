import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class GlowingMicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool animate;

  const GlowingMicButton({
    super.key,
    required this.onTap,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowCount: 3,
      glowRadiusFactor: 0.2,
      animate: animate,
      glowColor: Colors.orange.withAlpha((255 * 0.5).round()),
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              center: Alignment.center,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.5),
                blurRadius: animate ? 35 : 10,
                spreadRadius: animate ? 5 : 2,
              ),
            ],
          ),
          child: Icon(
            animate ? Icons.mic_rounded : Icons.mic_none_sharp,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
