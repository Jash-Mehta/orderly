import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SHOP',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1,
                    color: AppColors.gunmetal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Curated for you',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkElectricBlue,
                    letterSpacing: 0.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Cart icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:  AppColors.chineseBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

