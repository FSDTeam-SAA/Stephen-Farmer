import 'package:flutter/material.dart';

class ProgressStatCard extends StatelessWidget {
  const ProgressStatCard({super.key, required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 109,
        width: 109,
        decoration: BoxDecoration(
          color: const Color(0xFF111A1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFB9A77D)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE3D2AA), size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Color(0xFFD3DDE0), fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20, height: 1, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
