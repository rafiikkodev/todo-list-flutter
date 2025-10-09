import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:template_project_flutter/shared/theme.dart';

class CircularTimerWidget extends StatefulWidget {
  final int totalMinutes;
  final int totalSessions;
  final Color primaryColor;
  final Color backgroundColor;

  const CircularTimerWidget({
    super.key,
    this.totalMinutes = 25,
    this.totalSessions = 4,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  State<CircularTimerWidget> createState() => _CircularTimerWidgetState();
}

class _CircularTimerWidgetState extends State<CircularTimerWidget> {
  late Timer _timer;
  int _remainingSeconds = 0;
  int _currentSession = 1;
  bool _isRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalMinutes * 60;
  }

  void _startTimer() {
    if (!_isRunning && !_isPaused) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer.cancel();
          setState(() {
            _isRunning = false;
            if (_currentSession < widget.totalSessions) {
              _currentSession++;
              _remainingSeconds = widget.totalMinutes * 60;
            }
          });
        }
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = true;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer.cancel();
          setState(() {
            _isRunning = false;
            _isPaused = false;
            if (_currentSession < widget.totalSessions) {
              _currentSession++;
              _remainingSeconds = widget.totalMinutes * 60;
            }
          });
        }
      });
    }
  }

  void _resetTimer() {
    if (_isRunning || _isPaused) {
      _timer.cancel();
    }
    setState(() {
      _remainingSeconds = widget.totalMinutes * 60;
      _isRunning = false;
      _isPaused = false;
    });
  }

  void _stopTimer() {
    if (_isRunning || _isPaused) {
      _timer.cancel();
    }
    setState(() {
      _remainingSeconds = widget.totalMinutes * 60;
      _currentSession = 1;
      _isRunning = false;
      _isPaused = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_isRunning || _isPaused) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingSeconds == widget.totalMinutes * 60
        ? 0
        : 1 - (_remainingSeconds / (widget.totalMinutes * 60));

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Progress Timer
          SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: CircularTimerPainter(
                progress: progress,
                primaryColor: widget.primaryColor,
                backgroundColor: widget.backgroundColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: bold,
                        color: blackPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_currentSession of ${widget.totalSessions} sessions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: medium,
                        color: blackSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Stay focus for ${widget.totalMinutes} minutes',
            style: TextStyle(
              fontSize: 16,
              color: blackPrimaryColor,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 24),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset Button
              _buildControlButton(
                icon: Icons.refresh,
                onPressed: _resetTimer,
                isActive: false,
              ),
              const SizedBox(width: 24),
              // Play/Pause Button
              _buildControlButton(
                icon: _isRunning
                    ? Icons.pause
                    : _isPaused
                    ? Icons.play_arrow
                    : Icons.play_arrow,
                onPressed: _isRunning
                    ? _pauseTimer
                    : _isPaused
                    ? _resumeTimer
                    : _startTimer,
                isActive: true,
                isLarge: true,
              ),
              const SizedBox(width: 24),
              // Stop Button
              _buildControlButton(
                icon: Icons.stop,
                onPressed: _stopTimer,
                isActive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    bool isLarge = false,
  }) {
    final size = isLarge ? 80.0 : 60.0;
    final iconSize = isLarge ? 40.0 : 28.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? widget.primaryColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? widget.primaryColor : widget.backgroundColor,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: isActive ? whiteColor : widget.backgroundColor,
        ),
      ),
    );
  }
}

// Custom Painter untuk Circular Progress
class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;

  CircularTimerPainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background Circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress Arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Thumb
      final thumbAngle = startAngle + sweepAngle;
      final thumbX = center.dx + radius * math.cos(thumbAngle);
      final thumbY = center.dy + radius * math.sin(thumbAngle);

      final thumbPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(thumbX, thumbY), 14, thumbPaint);

      // Inner white circle for thumb
      final thumbInnerPaint = Paint()
        ..color = purplePrimary
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(thumbX, thumbY), 6, thumbInnerPaint);
    }
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
