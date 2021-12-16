import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/model/note_model.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({required this.note, required this.index});
  final NoteModel note;
  final int index;

  //to return different height for different widgets


  @override
  Widget build(BuildContext context) {
    final color = _lightColors[index % _lightColors.length];
    final date = DateFormat.yMMMd().format(note.creationDate);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  double getMinHeight(int index) {
    switch(index % 4) {
      case 0 :
        return 100;
      case 1 :
        return 150;
      case 2 :
        return 150;
      case 3 :
        return 100;
      default : return 100;
    }
  }
}
