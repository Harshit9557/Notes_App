import 'package:flutter/material.dart';
import 'package:notes_app/database/database_provider.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/screens/add_note.dart';

class ShowNote extends StatefulWidget {
  const ShowNote({required this.noteId});
  final int? noteId;

  @override
  _ShowNoteState createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {
  NoteModel? note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await DatabaseProvider.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if(isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNote(note: note),
        ));

        refreshNote();
      },
  );
  Widget deleteButton() => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await DatabaseProvider.instance.deleteNote(widget.noteId);
        Navigator.of(context).pop();
      },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton()
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: [
            Text(
              note!.title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(note!.creationDate),
              style: TextStyle(
                color: Colors.white38,
              ),
            ),
            SizedBox(height: 8),
            Text(
              note!.text!,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      )
    );

  }
}
