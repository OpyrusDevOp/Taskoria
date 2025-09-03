import 'package:flutter/material.dart';

class RankBadge extends StatelessWidget {
  final String rank;
  final Color color;
  final double size;
  final bool showGlow;

  const RankBadge({
    super.key,
    required this.rank,
    required this.color,
    this.size = 60,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: showGlow ? 0.4 : 0.2),
            blurRadius: showGlow ? 20 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),

          // Inner ring
          Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),

          // Star icon
          Icon(Icons.star, color: Colors.white, size: size * 0.4),
        ],
      ),
    );
  }
}
