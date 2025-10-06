import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
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
          // CustomButtonMedium(title: "Add Task", iconPath: "assets/ic-plus.png"),
          CustomButtonMedium(
            title: "Add Task",
            iconPath: "assets/ic-plus.png",
            onPressed: () {
              // Munculkan modal bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.black.withAlpha(200), // hitam transparan
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: blackThirdColor,
                        borderRadius: BorderRadius.vertical(
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
                                hintText:
                                    'Task title', // tampil di tengah dan hilang saat user ngetik
                                hintStyle: TextStyle(
                                  color: blackThirdColor,
                                  fontSize: 14,
                                  fontWeight:
                                      medium, // sedikit transparan biar beda dari teks input
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
                              style: TextStyle(
                                color: blackPrimaryColor, // warna teks user
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset("assets/ic-clock.png"),
                                Image.asset("assets/ic-send.png"),
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
          isActive: currentIndex >= index, // Tambahkan parameter isActive
          onPressed: () => _onTaskPressed(index),
        ),
      ),
    );
  }
}
