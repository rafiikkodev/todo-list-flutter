import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_timer.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Center(
              child: CircularTimerWidget(
                totalMinutes: 25,
                totalSessions: 4,
                primaryColor: purplePrimary,
                backgroundColor: blackThirdColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 85, left: 24, right: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset("assets/ic-back.png"),
          ),
          Expanded(
            child: Text(
              "Pomodoro",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: semiBold,
                color: blackPrimaryColor,
              ),
            ),
          ),
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
