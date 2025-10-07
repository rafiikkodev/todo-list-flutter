import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_calendar_dialog.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({super.key});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    // Load data after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _titleController.text = args['title'] ?? '';
        _descriptionController.text = args['description'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildForm(),
            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(24),
        child: CustomButtonLarge(title: "Delete Task", onPressed: () {}),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            child: Image.asset("assets/ic-cancel.png"),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: Image.asset(
              isEditing ? "assets/ic-check.png" : "assets/ic-edit.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title - always editable when isEditing = true
          IntrinsicHeight(
            child: TextField(
              controller: _titleController,
              enabled: isEditing,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: semiBold,
                color: blackPrimaryColor,
              ),
              cursorColor: blackPrimaryColor,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 12),

          // Description - always editable when isEditing = true
          TextField(
            controller: _descriptionController,
            enabled: isEditing,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: regular,
              color: blackPrimaryColor,
            ),
            cursorColor: blackPrimaryColor,
            maxLines: null,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/ic-clock.png"),
                  const SizedBox(width: 12),
                  Text(
                    "Task time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: semiBold,
                      color: blackPrimaryColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  final result = await showCustomCalendarPicker(
                    context,
                    initialDate: selectedDate ?? DateTime.now(),
                  );

                  if (result != null && mounted) {
                    setState(() {
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
                      final minute = selectedTime!.minute.toString().padLeft(
                        2,
                        '0',
                      );
                      final period = selectedTime!.period == DayPeriod.am
                          ? 'AM'
                          : 'PM';
                      final formattedTime = '$hour:$minute $period';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selected: $formattedDate | $formattedTime',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: CustomButtonMedium(
                  title: selectedDate != null && selectedTime != null
                      ? _formatDateTime(selectedDate!, selectedTime!)
                      : "dd/MM/yyyy",
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedDate | $hour:$minute $period';
  }
}
