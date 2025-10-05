import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';

class CustomButtonLarge extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const CustomButtonLarge({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: purplePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
        ),
      ),
    );
  }
}

class CustomButtonMedium extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final String? iconPath;
  final VoidCallback? onPressed;

  const CustomButtonMedium({
    super.key,
    required this.title,
    this.width = 171,
    this.height = 40,
    this.iconPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: purplePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              Image.asset(iconPath!, height: 10, width: 10),
              const SizedBox(width: 5),
            ],
            Text(
              title,
              style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtonMediumStroke extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const CustomButtonMediumStroke({
    super.key,
    required this.title,
    this.width = 171,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Color(0xff5A6BFF).withAlpha(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: purplePrimary, width: 2),
          ),
        ),
        child: Text(
          title,
          style: purpleTextStyle.copyWith(fontSize: 14, fontWeight: medium),
        ),
      ),
    );
  }
}

class CustomButtonLargePlaceholder extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const CustomButtonLargePlaceholder({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: purplePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
      ),
    );
  }
}


