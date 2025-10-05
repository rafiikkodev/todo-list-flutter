import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [buildHeader(), buildCalendar()],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/Profile Container.png"),
          CustomButtonMedium(title: "Add Task", iconPath: "assets/ic-plus.png"),
        ],
      ),
    );
  }

  Widget buildCalendar() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: DatePicker(
              DateTime.now(),
              width: 60,
              height: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color(0xff5A6BFF).withAlpha(25),
              selectedTextColor: purplePrimary,
              onDateChange: (date) {},
            ),
          ),
        ],
      ),
    );
  }
}
