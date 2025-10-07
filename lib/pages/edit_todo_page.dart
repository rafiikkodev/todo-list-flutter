import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/models/todo.dart';
import 'package:template_project_flutter/services/storage_service.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_calendar_dialog.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({super.key});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final StorageService _storageService = StorageService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  Todo? _currentTodo;
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
      if (args != null && args['todo'] != null) {
        _currentTodo = args['todo'] as Todo;
        _titleController.text = _currentTodo!.title;
        _descriptionController.text = _currentTodo!.description;
        selectedDate = _currentTodo!.date;

        // Parse time string to TimeOfDay
        final timeParts = _currentTodo!.time.split(':');
        if (timeParts.length == 2) {
          final hourMinute = timeParts[0];
          final minutePeriod = timeParts[1].split(' ');
          int hour = int.parse(hourMinute);
          final minute = int.parse(minutePeriod[0]);
          final period = minutePeriod.length > 1 ? minutePeriod[1] : '';

          if (period == 'PM' && hour != 12) {
            hour += 12;
          } else if (period == 'AM' && hour == 12) {
            hour = 0;
          }

          selectedTime = TimeOfDay(hour: hour, minute: minute);
        }

        setState(() {});
      }
    });
  }

  Future<void> _deleteTodo() async {
    if (_currentTodo == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _storageService.deleteTodo(_currentTodo!.id);
      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
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
            const SizedBox(height: 180), // Space for floating buttons
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomButtonLarge(
              title: "Delete Task",
              onPressed: _deleteTodo,
            ),
          ),
        ],
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
          // Title
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

          // Description
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

          // Date & Time
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
              if (isEditing)
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
                    }
                  },
                  child: CustomButtonMedium(
                    title: selectedDate != null && selectedTime != null
                        ? _formatDateTime(selectedDate!, selectedTime!)
                        : "dd/MM/yyyy",
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: blackThirdColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedDate != null && selectedTime != null
                        ? _formatDateTime(selectedDate!, selectedTime!)
                        : "No date set",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: medium,
                      color: blackPrimaryColor,
                    ),
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
