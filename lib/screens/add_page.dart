// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_declarations, unused_local_variable, use_build_context_synchronously

import 'package:flutter_todo_rest/screens/utils/snackbar_helpers.dart';
import 'package:flutter_todo_rest/services/todo_service.dart';

import 'package:flutter/material.dart';

class AddToDoPg extends StatefulWidget {
  final Map? todo;
  const AddToDoPg({super.key, this.todo});

  @override
  State<AddToDoPg> createState() => _AddToDoPgState();
}

class _AddToDoPgState extends State<AddToDoPg> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: ListView(
        padding: EdgeInsets.all(10),
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //get data from server
    final todo = widget.todo;
    if (todo == null) {
      print('object');
      return;
    }
    final id = todo['_id'];
    /*final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };*/

    //submit updated data to server

    //final url = 'http://api.nstack.in/v1/todos/$id';
    //final uri = Uri.parse(url);

    final isSuccess = await TodoService.updateTodo(id, body);

    //Submit data to server
    if (isSuccess) {
      showSucessMessage(context, message: 'Updated Successfully');
    } else {
      showErrorMessage(context, message: 'Updation Failed');
    }
  }

  Future<void> submitData() async {
    /*final title = titleController.text;
    final description = descriptionController.text;
    final body = {
    "title": title,
      "description": description,
      "is_completed": false,
    };*/
    //final url = 'http://api.nstack.in/v1/todos';
    //final uri = Uri.parse(url);
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSucessMessage(context, message: 'Created Successfully');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body {
    //get the data
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
