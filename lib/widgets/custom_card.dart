import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';

class CustomCardTodo extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time; // sementara pake string
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const CustomCardTodo({
    super.key,
    required this.title,
    required this.subTitle,
    this.width = 296,
    this.height = 109,
    this.onPressed,
    required this.time,
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
                  SizedBox(width: 16),
                  Text(
                    time,
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
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
  final String time; // sementara pake string
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
                  value: 0.55,
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
