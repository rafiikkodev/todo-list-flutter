import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_card.dart';
import 'package:template_project_flutter/widgets/custom_calendar_dialog.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int currentIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
            onTap: () => Navigator.pop(context),
            child: Image.asset("assets/ic-back.png"),
          ),
          CustomButtonMedium(
            title: "Add Task",
            iconPath: "assets/ic-plus.png",
            onPressed: () => _showAddTaskModal(context),
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
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
                      _buildModalHandle(),
                      _buildModalTitle(),
                      const SizedBox(height: 16),
                      _buildTitleTextField(),
                      const SizedBox(height: 16),
                      _buildDescriptionTextField(),
                      const SizedBox(height: 16),
                      _buildModalActions(context, setModalState),
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
  }

  Widget _buildModalHandle() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildModalTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Add Task",
        style: TextStyle(
          fontSize: 24,
          fontWeight: semiBold,
          color: blackPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
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
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
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
    );
  }

  Widget _buildModalActions(BuildContext context, StateSetter setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            final result = await showCustomCalendarPicker(
              context,
              initialDate: selectedDate ?? DateTime.now(),
            );

            if (result != null && context.mounted) {
              setModalState(() {
                selectedDate = result['date'] as DateTime?;
                selectedTime = result['time'] as TimeOfDay?;
              });

              // Format tanggal dan waktu
              if (selectedDate != null && selectedTime != null) {
                final formattedDate = DateFormat(
                  'dd/MM/yyyy',
                ).format(selectedDate!);
                final hour = selectedTime!.hourOfPeriod == 0
                    ? 12
                    : selectedTime!.hourOfPeriod;
                final minute = selectedTime!.minute.toString().padLeft(2, '0');
                final period = selectedTime!.period == DayPeriod.am
                    ? 'AM'
                    : 'PM';
                final formattedTime = '$hour:$minute $period';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: $formattedDate | $formattedTime'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          child: Row(
            children: [
              Image.asset("assets/ic-clock.png"),
              if (selectedDate != null && selectedTime != null) ...[
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(selectedDate!, selectedTime!),
                  style: TextStyle(
                    color: blackPrimaryColor,
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle send task
          },
          child: Image.asset("assets/ic-send.png"),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedDate | $hour:$minute $period';
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
          selectedTextColor: whiteColor,
          selectionColor: purplePrimary,
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
      itemBuilder: (context, index) => _buildStepperItem(index),
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
