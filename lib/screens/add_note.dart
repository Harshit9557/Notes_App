import 'package:flutter/material.dart';
import 'package:notes_app/database/database_provider.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/widgets/note_form_widget.dart';

class AddNote extends StatefulWidget {
  final NoteModel? note;

  const AddNote({this.note});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  late int? number;
  late String? title;
  late String? text;

  @override
  void initState() {
    super.initState();

    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    text = widget.note?.text ?? '';
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating)
        await updateNote();
      else
        await addNote();

      Navigator.of(context).pop();
    }
  }

  //function to update note
  Future updateNote() async {
    final note = widget.note!.copy(
      number: number,
      title: title,
      text: text,
    );

    await DatabaseProvider.instance.update(note);
  }

  //function to add new note
  Future addNote() async {
    final note = NoteModel(
      title: title,
      number: number,
      text: text,
      creationDate: DateTime.now(),
    );

    await DatabaseProvider.instance.addNewNote(note);
  }

  Widget buildButton() {
    final isFormValid = title!.isNotEmpty && text!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          text: text,
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedNumber: (number) => setState(() => this.number = number),
          onChangedText: (text) => setState(() => this.text = text),
        ),
      ),
    );
  }
}
