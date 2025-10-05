import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';

class CustomCategory extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const CustomCategory({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Color(0xff5A6BFF).withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: purplePrimary),
            ),
            child: Center(child: Image.asset(iconPath, fit: BoxFit.contain)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: blackPrimaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}
