import 'package:flutter/material.dart';

var _currencies = [
  "Food",
  "Transport",
  "Personal",
  "Shopping",
  "Medical",
  "Rent",
  "Movie",
  "Salary"
];

class TextDropdownFiedls extends StatefulWidget {
  const TextDropdownFiedls({Key? key}) : super(key: key);

  @override
  State<TextDropdownFiedls> createState() => _TextDropdownFiedlsState();
}

class _TextDropdownFiedlsState extends State<TextDropdownFiedls> {
  String _currentSelectedValue = 'Transport';

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
              errorStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Please select expense',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedValue = newValue!;
                });
              },
              items: _currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
