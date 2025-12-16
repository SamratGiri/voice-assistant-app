// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class GlowingMicButton extends StatefulWidget {
  final VoidCallback onTap;
  const GlowingMicButton({super.key, required this.onTap});

  @override
  State<GlowingMicButton> createState() => _GlowingMicButtonState();
}

class _GlowingMicButtonState extends State<GlowingMicButton> {
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowCount: 3,
      glowRadiusFactor: 0.3,
      animate: _isActive,
      glowColor: Colors.orange.withOpacity(0.5),
      duration: Duration(milliseconds: 10000),
      repeat: true,

      child: GestureDetector(
        onTap: () {
          setState(() {
            _isActive = !_isActive;
          });
          widget.onTap;
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrange,
              ], // Bright to dark orange
              center: Alignment.center, // Shine from top for 3D feel
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.orange, blurRadius: 35, spreadRadius: 5),
            ],
          ),
          child: const Icon(Icons.mic_none_sharp, size: 35),
        ),
      ),
    );
  }
}
