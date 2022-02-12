import 'package:flutter/material.dart';

var items = ["101", "102", "103", "104", "105", "106", "107", "108"];

class EditTextDropDownField extends StatefulWidget {
  const EditTextDropDownField({Key? key}) : super(key: key);

  @override
  _EditTextDropDownFieldState createState() => _EditTextDropDownFieldState();
}

class _EditTextDropDownFieldState extends State<EditTextDropDownField> {
  final TextEditingController _controller = TextEditingController();
  var color = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        border: const OutlineInputBorder(),
        labelText: 'Item Id',
        hintText: 'Item Id',
        suffixIcon: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: color,
            splashColor: color,
            hoverColor: color,
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            tooltip: 'Show Item Ids',
            onSelected: (String value) {
              _controller.text = value;
            },
            itemBuilder: (BuildContext context) {
              return items.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem(child: Text(value), value: value);
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
