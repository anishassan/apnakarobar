import 'package:flutter/material.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/utils/app_text.dart';

class CustomDateTimePicker extends StatefulWidget {
  final Function(DateTime) onPress;

  const CustomDateTimePicker({super.key, required this.onPress});
  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime _selectedDate = DateTime.now();

  List<String> _dateOptions = [];

  @override
  void initState() {
    super.initState();
    _generateDateOptions();
  }

  void _generateDateOptions() {
    DateTime today = DateTime.now();
    _dateOptions = List.generate(1000, (index) {
      DateTime date = today.subtract(Duration(days: index));
      return "${date.day.toString().padLeft(2, '0')}/${(date.month).toString().padLeft(2, '0')}/${date.year}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          isExpanded: false,
          elevation: 0,
          value:
              "${_selectedDate.day.toString().padLeft(2, '0')}/${(_selectedDate.month).toString().padLeft(2, '0')}/${_selectedDate.year}",
          onChanged: (String? newValue) {
            setState(() {
              // Parse the new date string to DateTime
              List<String> parts = newValue!.split('/');
              _selectedDate = DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );
            });
            widget.onPress(_selectedDate);
          },
          items: _dateOptions.map<DropdownMenuItem<String>>((String date) {
            return DropdownMenuItem<String>(
                value: date,
                child: appText(title: date, context: context, fontSize: 12));
          }).toList(),
        ),
      ],
    );
  }
}
