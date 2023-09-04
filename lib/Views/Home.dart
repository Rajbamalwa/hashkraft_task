import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hashkraft_task/Views/AddTask.dart';

import '../utils/taskNavigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var user = FirebaseAuth.instance.currentUser;

  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff324c64),
        title: const Text('HashKraft Task',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 22)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('hashCraft')
                    .doc('userTask')
                    .collection(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Task Added',
                            style: TextStyle(
                                color: Color(0xff4e6f8b),
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Add Tasks to manage your work load in\na proper way.',
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff324c64),
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Card(
                              color: const Color(0xff416480),
                              elevation: 5,
                              child: ListTile(
                                  leading: IconButton(
                                      tooltip: data['isCompleted'] == false
                                          ? 'InComplete Task'
                                          : 'Complete Task',
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('hashCraft')
                                            .doc('userTask')
                                            .collection(user!.uid)
                                            .doc(data.id)
                                            .update({'isCompleted': true});

                                        Fluttertoast.showToast(
                                            msg: 'Task Completed',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            fontSize: 15);
                                      },
                                      icon: Icon(
                                        data['isCompleted'] == false
                                            ? Icons.clear
                                            : Icons.check,
                                        color: data['isCompleted'] == false
                                            ? Colors.black
                                            : Colors.white,
                                      )),
                                  title: Text(data['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 15)),
                                  subtitle: Text(data['details'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 12)),
                                  trailing: PopupMenuButton(
                                    position: PopupMenuPosition.under,
                                    icon: const Icon(
                                      Icons.more_vert_sharp,
                                      color: Colors.white,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        TaskNavi()
                                            .navigateToEditPage(data, context);
                                      } else if (value == 'delete') {
                                        await FirebaseFirestore.instance
                                            .collection('hashCraft')
                                            .doc('userTask')
                                            .collection(user!.uid)
                                            .doc(data.id)
                                            .delete();
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              Text('Edit')
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.blue,
                                              ),
                                              Text('Delete')
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                  )),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff324c64),
        tooltip: 'Add Tasks',
        onPressed: () {
          TaskNavi().navigateToAddPage(context);
          // Navigator.push(context, MaterialPageRoute(builder: (_) => AddTask()));
        },
        label: Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
