import 'package:flutter/material.dart';

class FinancialsRemainingBalanceCard extends StatelessWidget {
  const FinancialsRemainingBalanceCard({super.key, required this.amountText, required this.paidPercent});

  final String amountText;
  final int paidPercent;

  @override
  Widget build(BuildContext context) {
    final safePercent = paidPercent.clamp(0, 100);

    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFD8D5CD), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remaining Balance',
                  style: TextStyle(color: Color(0xFF232323), fontSize: 13, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 8),
                Text(
                  amountText,
                  style: const TextStyle(color: Color(0xFF232323), fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          /* Container(
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            height: 65,
            width: 65,
            child: CircularProgressIndicator(
              value: safePercent / 100,
              strokeWidth: 4,

              strokeCap: StrokeCap.round,
              // backgroundColor: const Color(0xFFBFB8AA),
              color: const Color(0xFFC08A2B),
              valueColor: AlwaysStoppedAnimation<Color>(safePercent >= 100 ? const Color(0xFF34C759) : const Color(0xFFC08A2B)),
            ),
          ), */
          Container(
            height: 65,
            width: 65,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: CircularProgressIndicator(
                    value: safePercent / 100,
                    strokeWidth: 5,
                    strokeCap: StrokeCap.round,
                    //backgroundColor: const Color(0xFFBFB8AA),
                    valueColor: AlwaysStoppedAnimation<Color>(safePercent >= 100 ? const Color(0xFF34C759) : const Color(0xFFC08A2B)),
                  ),
                ),
                Text(
                  "${safePercent.toInt()}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: safePercent >= 100 ? const Color(0xFF34C759) : const Color(0xFFC08A2B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
