import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  const NoteDetail({super.key, this.appBarTitle = "Add Note"});
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  final List<String> _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final String appBarTitle;

  NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

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
                    value: 'Low',
                    onChanged: (selectedItem) {
                      setState(() {
                        print('User selected $selectedItem');
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
                      print('Something changed in the title field');
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
                      print('Something changed in the description field');
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
                          print('Save button clicked');
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
                          print('delete button clicked');
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
    Navigator.pop(context);
  }
}
