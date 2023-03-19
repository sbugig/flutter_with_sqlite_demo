import 'package:flutter/material.dart';
import 'package:flutter_with_sqlite/models/note.dart';
import 'package:flutter_with_sqlite/screens/note_detail.dart';
import 'package:flutter_with_sqlite/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Note> noteList=[];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      noteList = List.empty();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        var currentNote = noteList[index];
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(currentNote.priority),
              child: getPriorityIcon(currentNote.priority),
            ),
            title: Text(
              currentNote.title,
              style: titleStyle,
            ),
            subtitle: Text(currentNote.date),
            trailing: GestureDetector(
              child: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(currentNote);
              },
            ),
            onTap: () {
              navigateToDetails(currentNote, 'Edit Note');
            },
          ),
        );
      },
    );
  }

// Returns the priority color

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

// Return the priority icon

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(Note note) async {
    int result = await databaseHelper.deleteNote(note.id);

    if (result != 0) {
      _showSnackBar('Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetails(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return NoteDetail(
          note: note,
          appBarTitle: title,
        );
      },
    ));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbPromise = databaseHelper.initialiseDatabase();
    dbPromise.then((database) {
      databaseHelper.getNoteList().then((noteList) {
        this.noteList = noteList;
        count = noteList.length;
      });
    });
  }
}
