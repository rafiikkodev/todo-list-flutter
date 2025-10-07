import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';

class CustomCardTodo extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final bool isActive;

  const CustomCardTodo({
    super.key,
    required this.title,
    required this.subTitle,
    this.width = 296,
    this.height = 109,
    this.onPressed,
    required this.time,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isActive ? purplePrimary : blackThirdColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    time,
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                subTitle,
                style: whiteTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardHome extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final String progress;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const CustomCardHome({
    super.key,
    required this.title,
    required this.subTitle,
    required this.time,
    required this.progress,
    this.width = 206,
    this.height = 206,
    this.onPressed,
  });

  // Parse progress string to double (e.g., "55%" -> 0.55)
  double _parseProgress() {
    try {
      final numericString = progress.replaceAll('%', '').trim();
      final value = double.parse(numericString);
      return value / 100;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = _parseProgress();

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: purplePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
              Text(
                subTitle,
                style: whiteTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
              Text(
                time,
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress",
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    progress,
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: LinearProgressIndicator(
                  value: progressValue.clamp(0.0, 1.0),
                  minHeight: 5,
                  valueColor: AlwaysStoppedAnimation(whiteColor),
                  backgroundColor: whiteColor.withAlpha(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
