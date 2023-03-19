import 'package:flutter/material.dart';
import 'package:flutter_with_sqlite/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails("Add Note");
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
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              'Dummy Title',
              style: titleStyle,
            ),
            subtitle: const Text('Dummy Date'),
            trailing: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              navigateToDetails("Edit Note");
            },
          ),
        );
      },
    );
  }

  void navigateToDetails(String title) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const NoteDetail();
      },
    ));
  }
}
