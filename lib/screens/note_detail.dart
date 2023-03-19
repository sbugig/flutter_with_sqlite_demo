import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note? note;
  const NoteDetail({super.key, this.note, this.appBarTitle = ''});
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note!, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();
  final List<String> _priorities = ['High', 'Low'];
  final String appBarTitle;
  final Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () async {
          moveToLastScreen();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //First Element
                ListTile(
                  title: DropdownButton(
                    items: getItems(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (selectedItem) {
                      setState(() {
                        //print('User selected $selectedItem');
                        updatePriorityAsInt(selectedItem);
                      });
                    },
                  ),
                ),

                // Second Element

                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Third Element

                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      //print('Something changed in the description field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //fourth Element

                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () {
                        setState(() {
                          //print('Save button clicked');
                          _save();
                        });
                      },
                    )),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        setState(() {
                          //print('delete button clicked');
                          _delete();
                        });
                      },
                    ))
                  ]),
                )
              ],
            ),
          ),
        ));
  }

  List<DropdownMenuItem> getItems() {
    return _priorities.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // convert the string priority to integer

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority = "Low";
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;

      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    int result;

    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();
    int result;

    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    result = await helper.deleteNote(note.id);

    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }
}
