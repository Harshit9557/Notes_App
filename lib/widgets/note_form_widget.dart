import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  const NoteFormWidget({
    this.number = 0,
    this.title = '',
    this.text = '',
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedText,
  });

  final int? number;
  final String? title;
  final String? text;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedText;

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    style: TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) => title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildText() => TextFormField(
    maxLines: 6,
    initialValue: text,
    style: TextStyle(
      color: Colors.white60,
      fontSize: 18,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Description',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (text) => text != null && text.isEmpty ? 'The description cannot be empty' : null,
    onChanged: onChangedText,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: (number ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (number) => onChangedNumber(number.toInt()),
                  ),
                ),
              ],
            ),
            buildTitle(),
            SizedBox(height: 8),
            buildText(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
