import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/buttons.dart';
import '../Widgets/textfield.dart';

class AddTask extends StatefulWidget {
  var item;

  AddTask({required this.item});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool loading = false;
  TextEditingController controller = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _typeController = TextEditingController();
  bool isEdit = false;
  String dropdownValue = '';
  var id;
  @override
  void initState() {
    final item = widget.item;
    if (item != null) {
      isEdit = true;
      final title = item['title'];
      final description = item['details'];
      final type = item['type'];
      final id = item['id'];
      _titleController.text = title;
      _descController.text = description!;
      _typeController.text = type!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff324c64),
        title: const Text('Add Tasks',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 22)),
      ),
      body: ListView(
        children: [
          textFIeld(_titleController, (value) {
            if (value!.isEmpty) {
              return 'Please Type Title';
            }
            return null;
          }, 'Event Title', 1, TextInputType.name, const Icon(Icons.add_task)),
          textFIeld(_descController, (value) {
            if (value!.isEmpty) {
              return 'Please Description';
            }
            return null;
          }, 'Description', 5, TextInputType.name,
              const Icon(Icons.topic_outlined)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: TextField(
              controller: _typeController,
              maxLines: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                suffixIcon: DropdownButton<String>(
                  underline: SizedBox(),
                  value: dropdownValue,
                  alignment: Alignment.topRight,
                  onChanged: (String? newValue) {
                    setState(() {
                      //  dropdownValue = newValue!;
                      _typeController.text = newValue!;
                    });
                  },
                  items: <String>[
                    '',
                    'Empty 📭',
                    'Family Time',
                    'Office Time',
                    'Birthday 🎂',
                    'Meeting 🤝🏻',
                    'Trip 🧳',
                    'Study Time 📚',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                icon: const Icon(Icons.add_box),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Colors.grey, style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Colors.grey, style: BorderStyle.solid)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Colors.grey, style: BorderStyle.none)),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                label: Text(
                  'Event Type',
                  style: TextStyle(color: Color(0xff294151)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Buttons(
              loading: loading,
              color: Color(0xff324c64),
              onPress: () {
                if (_titleController.text.isEmpty ||
                    _descController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Field Empty',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 15);
                } else {
                  if (isEdit == true) {
                    updateTask();
                    Navigator.pop(context);
                  } else {
                    addTask();
                    Navigator.pop(context);
                  }
                }
              },
              height: 60,
              child: Text(isEdit == true ? 'Edit' : 'Save',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 22)),
            ),
          ),
        ],
      ),
    );
  }

  // This Function is used to add user Tasks
  addTask() async {
    setState(() {
      loading = true;
    });
    var set = FirebaseFirestore.instance
        .collection('hashCraft')
        .doc('userTask')
        .collection(user!.uid)
        .add({
      'title': _titleController.text,
      'details': _descController.text,
      'type': dropdownValue.toString(),
      'isCompleted': false,
      'date': DateTime.now(),
      'id': ''
    }).then((value) {
      setState(() {
        loading = false;
      });

      FirebaseFirestore.instance
          .collection('hashCraft')
          .doc('userTask')
          .collection(user!.uid)
          .doc(value.id)
          .update({
        'id': value.id.toString(),
      });

      Fluttertoast.showToast(
          msg: 'Added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 15);
    }).then((value) {
      setState(() {
        loading = false;
      });
    });
    setState(() {
      loading = false;
    });
  }

  // This Function is used to updata user Tasks
  updateTask() async {
    setState(() {
      loading = true;
    });
    var set = FirebaseFirestore.instance
        .collection('hashCraft')
        .doc('userTask')
        .collection(user!.uid)
        .doc(widget.item['id'].toString())
        .update({
      'title': _titleController.text,
      'details': _descController.text,
      'type': dropdownValue.toString(),
      'date': DateTime.now(),
      'id': widget.item['id'].toString()
    }).then((value) {
      setState(() {
        loading = false;
      });

      Fluttertoast.showToast(
          msg: 'Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 15);
    });
    setState(() {
      loading = false;
    });
  }
}
