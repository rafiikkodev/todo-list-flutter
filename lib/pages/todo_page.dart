import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_card.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int currentIndex = 0;
  DateTime? selectedDate;

  final List<Map<String, String>> todoList = [
    {
      'title': 'Design Meeting',
      'description':
          'dolor sit amet, consectetur adipiscing elit. Morbi nec feugiat lorem dolor sit amet, consectetur adipiscing elit. Morbi nec feugiat lorem dolor sit amet, consectetur adipiscing elit. Morbi nec feugiat lorem',
      'time': '09:00 AM',
    },
    {
      'title': 'Code Review',
      'description': 'Review pull requests from team',
      'time': '11:30 AM',
    },
    {
      'title': 'Lunch Break',
      'description': 'Team lunch at nearby restaurant',
      'time': '01:00 PM',
    },
    {
      'title': 'Development',
      'description': 'Continue working on feature implementation',
      'time': '02:30 PM',
    },
    {
      'title': 'Testing',
      'description': 'Write unit tests for new features',
      'time': '04:00 PM',
    },
    {
      'title': 'Documentation',
      'description': 'Update API documentation',
      'time': '05:30 PM',
    },
  ];

  void _onTaskPressed(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildCalendar(),
          Expanded(child: _buildScrollableStepper()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 85, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/ic-back.png"),
          ),
          CustomButtonMedium(
            title: "Add Task",
            iconPath: "assets/ic-plus.png",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.black.withAlpha(200),
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: blackThirdColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  height: 5,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: blackThirdColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Add Task",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: semiBold,
                                      color: blackPrimaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: whiteColor,
                                    hintText: 'Task title',
                                    hintStyle: TextStyle(
                                      color: blackThirdColor,
                                      fontSize: 14,
                                      fontWeight: medium,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 24,
                                    ),
                                  ),
                                  style: TextStyle(color: blackPrimaryColor),
                                  cursorColor: blackPrimaryColor,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: whiteColor,
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                      color: blackThirdColor,
                                      fontSize: 14,
                                      fontWeight: medium,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 24,
                                    ),
                                  ),
                                  style: TextStyle(color: blackPrimaryColor),
                                  cursorColor: blackPrimaryColor,
                                  minLines: 3,
                                  maxLines: null,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final DateTime? picked =
                                            await showCustomCalendarPicker(
                                              context,
                                              initialDate:
                                                  selectedDate ??
                                                  DateTime.now(),
                                            );

                                        if (picked != null) {
                                          setModalState(() {
                                            selectedDate = picked;
                                          });

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Date selected: ${DateFormat('dd MMMM yyyy').format(picked)}',
                                              ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset("assets/ic-clock.png"),
                                          if (selectedDate != null) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(selectedDate!),
                                              style: TextStyle(
                                                color: blackPrimaryColor,
                                                fontSize: 14,
                                                fontWeight: medium,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset("assets/ic-send.png"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: SizedBox(
        height: 100,
        child: DatePicker(
          DateTime.now(),
          width: 60,
          height: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: const Color(0xff5A6BFF).withAlpha(25),
          selectedTextColor: purplePrimary,
          onDateChange: (date) {
            // Handle date change
          },
        ),
      ),
    );
  }

  Widget _buildScrollableStepper() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        return _buildStepperItem(index);
      },
    );
  }

  Widget _buildStepperItem(int index) {
    final item = todoList[index];
    final isLast = index == todoList.length - 1;
    final isCompleted = currentIndex > index;
    final isActive = currentIndex >= index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepperIndicator(index, isLast, isCompleted, isActive),
        const SizedBox(width: 16),
        _buildTaskCard(index, item, isLast),
      ],
    );
  }

  Widget _buildStepperIndicator(
    int index,
    bool isLast,
    bool isCompleted,
    bool isActive,
  ) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? purplePrimary : blackThirdColor,
            border: Border.all(
              color: isActive ? purplePrimary : blackThirdColor,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 14, color: whiteColor)
                : const SizedBox.shrink(),
          ),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 100,
            color: isCompleted ? purplePrimary : blackThirdColor,
          ),
      ],
    );
  }

  Widget _buildTaskCard(int index, Map<String, String> item, bool isLast) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
        child: CustomCardTodo(
          title: item['title']!,
          subTitle: item['description']!,
          time: item['time']!,
          width: double.infinity,
          isActive: currentIndex >= index,
          onPressed: () => _onTaskPressed(index),
        ),
      ),
    );
  }
}

Future<DateTime?> showCustomCalendarPicker(
  BuildContext context, {
  DateTime? initialDate,
}) async {
  return showDialog<DateTime>(
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _previousMonth,
                      child: Image.asset("assets/ic-back.png"),
                    ),
                    Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(_currentMonth).toUpperCase(),
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
                ),
                const SizedBox(height: 22),
                Row(
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
                ),
                const SizedBox(height: 10),
                _buildCalendarGrid(),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
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
                    onPressed: () {
                      if (_selectedDate != null) {
                        Navigator.pop(context, _selectedDate);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = daysInPreviousMonth - i;
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false));
    }

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
}
