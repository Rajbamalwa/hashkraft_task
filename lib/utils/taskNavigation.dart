import 'package:flutter/material.dart';

import '../Views/AddTask.dart';

class TaskNavi {
  // This navigateToEditPage function is used to edit user defined event
  void navigateToEditPage(item, context) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTask(
              item: item,
            ));
    await Navigator.push(context, route);
  }

  // This navigateToAddPage function is used add user event
  void navigateToAddPage(context) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTask(
              item: null,
            ));
    await Navigator.push(context, route);
  }
}
