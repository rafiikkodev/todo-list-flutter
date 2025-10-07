import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';

/// Shows a custom time picker dialog
Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
}) async {
  return showDialog<TimeOfDay>(
    context: context,
    barrierColor: Colors.black.withAlpha(200),
    builder: (BuildContext context) {
      return CustomTimePickerDialog(initialTime: initialTime);
    },
  );
}

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay? initialTime;

  const CustomTimePickerDialog({super.key, this.initialTime});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  int _selectedHour = 8;
  int _selectedMinute = 45;
  int _selectedPeriod = 0; // 0 = AM, 1 = PM

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null) {
      _selectedHour = widget.initialTime!.hourOfPeriod == 0
          ? 12
          : widget.initialTime!.hourOfPeriod;
      _selectedMinute = widget.initialTime!.minute;
      _selectedPeriod = widget.initialTime!.period == DayPeriod.am ? 0 : 1;
    }

    _hourController = FixedExtentScrollController(
      initialItem: _selectedHour - 1,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
    _periodController = FixedExtentScrollController(
      initialItem: _selectedPeriod,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimePickerContainer(),
          const SizedBox(height: 12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTimePickerContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Time',
            style: TextStyle(fontSize: 14, fontWeight: medium),
          ),
          const SizedBox(height: 12),
          _buildTimeScrollers(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTimeScrollers() {
    return SizedBox(
      height: 142,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour
          _buildScrollPicker(
            controller: _hourController,
            itemCount: 12,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedHour = index + 1;
              });
            },
            itemBuilder: (index) => (index + 1).toString().padLeft(2, '0'),
          ),

          // Separator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 6, color: blackThirdColor),
                SizedBox(height: 8),
                Icon(Icons.circle, size: 6, color: blackThirdColor),
              ],
            ),
          ),

          // Minute
          _buildScrollPicker(
            controller: _minuteController,
            itemCount: 60,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMinute = index;
              });
            },
            itemBuilder: (index) => index.toString().padLeft(2, '0'),
          ),

          const SizedBox(width: 16),

          // AM/PM
          _buildScrollPicker(
            controller: _periodController,
            itemCount: 2,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedPeriod = index;
              });
            },
            itemBuilder: (index) => index == 0 ? 'AM' : 'PM',
          ),
        ],
      ),
    );
  }

  Widget _buildScrollPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Function(int) onSelectedItemChanged,
    required String Function(int) itemBuilder,
  }) {
    return SizedBox(
      width: 70,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 60,
        perspective: 0.002,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected = (controller.selectedItem == index);
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? blackThirdColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                itemBuilder(index),
                style: TextStyle(
                  fontSize: isSelected ? 28 : 18,
                  fontWeight: isSelected ? semiBold : regular,
                  color: isSelected ? blackPrimaryColor : blackThirdColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
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
              title: "Save",
              onPressed: () {
                int hour24 = _selectedHour;
                if (_selectedPeriod == 1) {
                  // PM
                  if (_selectedHour != 12) hour24 += 12;
                } else {
                  // AM
                  if (_selectedHour == 12) hour24 = 0;
                }

                final selectedTime = TimeOfDay(
                  hour: hour24,
                  minute: _selectedMinute,
                );
                Navigator.pop(context, selectedTime);
              },
            ),
          ),
        ],
      ),
    );
  }
}
