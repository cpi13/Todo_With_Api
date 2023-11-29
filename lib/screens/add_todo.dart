import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/screens/todo_list.dart';
import 'package:todo_api/services/todo_service.dart';

import '../utils/snackBar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Title",

            ),

          ),
          SizedBox(height: 10,),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                hintText: "Description"
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData, child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(isEdit ? "Update" : "Submit"),
          )),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You can  not call updated without todo data");
      return;
    }
    final id = todo['_id'];

    //submit updated data to the server
    final isSuccess = await TodoServices.updateTodo(id, body);
    // show success or failure message
    if (isSuccess) {
      showSuccessMessage(context, msg: "Updation Success");
    }
    else
      showFailureMessage(context, msg: "Updation Failure");
  }

  Future<void> submitData() async {
    //get the  data from the form
    final isSuccess = await TodoServices.addTodo(body);
    // show success or failure message
    if (isSuccess) {
      titleController.text = '';
      descController.text = '';
      showSuccessMessage(context, msg: "Creation Success");
    }
    else
      showFailureMessage(context, msg: "Creation Failure");
  }
  Map get body{
    //get the data from the map
    final title = titleController.text;
    final description = descController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }
}

