import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_clock_dialog.dart';

/// Shows a custom calendar picker dialog
Future<Map<String, dynamic>?> showCustomCalendarPicker(
  BuildContext context, {
  DateTime? initialDate,
}) async {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.black.withAlpha(200),
    builder: (BuildContext context) {
      return CustomCalendarDialog(initialDate: initialDate);
    },
  );
}

class CustomCalendarDialog extends StatefulWidget {
  final DateTime? initialDate;

  const CustomCalendarDialog({super.key, this.initialDate});

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
    _selectedDate = widget.initialDate;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _handleChooseTime() async {
    if (_selectedDate == null) return;

    // Simpan context dalam variable lokal
    final navigator = Navigator.of(context);

    // Buka dialog time picker
    final TimeOfDay? pickedTime = await showCustomTimePicker(
      context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted) return;

    if (pickedTime != null) {
      // Return both date and time
      navigator.pop({'date': _selectedDate, 'time': pickedTime});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCalendarContainer(),
          const SizedBox(height: 12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCalendarContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMonthNavigator(),
          const SizedBox(height: 22),
          _buildWeekdayHeaders(),
          const SizedBox(height: 10),
          _buildCalendarGrid(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _previousMonth,
          child: Image.asset("assets/ic-back.png"),
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: medium,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: _nextMonth,
          child: Image.asset("assets/ic-next.png"),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
          .map(
            (day) => SizedBox(
              width: 25,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: bold,
                    color: blackThirdColor,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final previousMonth = DateTime(_currentMonth.year, _currentMonth.month, 0);
    final daysInPreviousMonth = previousMonth.day;

    List<Widget> dayWidgets = [];

    // Previous month days
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = daysInPreviousMonth - i;
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected =
          _selectedDate != null &&
          date.year == _selectedDate!.year &&
          date.month == _selectedDate!.month &&
          date.day == _selectedDate!.day;

      dayWidgets.add(
        _buildDayCell(
          day,
          isCurrentMonth: true,
          isSelected: isSelected,
          date: date,
        ),
      );
    }

    // Next month days
    final remainingCells = 42 - dayWidgets.length;
    for (int day = 1; day <= remainingCells; day++) {
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false));
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
    int day, {
    required bool isCurrentMonth,
    bool isSelected = false,
    DateTime? date,
  }) {
    return GestureDetector(
      onTap: isCurrentMonth && date != null ? () => _selectDate(date) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? purplePrimary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? whiteColor
                  : isCurrentMonth
                  ? blackPrimaryColor
                  : blackThirdColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomButtonMediumStrokeWhite(
              title: "Cancel",
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButtonMedium(
              title: "Choose Time",
              onPressed: _selectedDate != null ? _handleChooseTime : null,
            ),
          ),
        ],
      ),
    );
  }
}
