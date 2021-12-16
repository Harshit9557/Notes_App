import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/database/database_provider.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/screens/display_note.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/widgets/note_card_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<NoteModel> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose(){
    DatabaseProvider.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await DatabaseProvider.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8.0),
    crossAxisCount: 4,
    itemCount: notes.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowNote(noteId: note.id),
          ));

          refreshNotes();
        },
        child: NoteCardWidget(
          note: note,
          index: index,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Create Future builder to display the element
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 12)
        ],
      ),
      body: Center(
        child: isLoading ? CircularProgressIndicator() : notes.isEmpty ? Text(
          'You haven\'t created any notes yet. Create one',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ) : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNote()),);
          refreshNotes();
        },
      ),
    );

  }
}