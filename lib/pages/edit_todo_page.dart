import 'package:flutter/material.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({super.key});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [_buildHeader(context)]));
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
          CustomButtonMedium(title: "Add Task", iconPath: "assets/ic-plus.png"),
        ],
      ),
    );
  }
}
