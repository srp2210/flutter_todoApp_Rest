// ignore_for_file: prefer_const_constructors, avoid_web_libraries_in_flutter, prefer_const_declarations, sort_child_properties_last, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_todo_rest/screens/add_page.dart';
import 'package:flutter_todo_rest/screens/utils/snackbar_helpers.dart';
import 'package:flutter_todo_rest/services/todo_service.dart';
import 'package:flutter_todo_rest/widgets/todo_card.dart';

class TodoListPg extends StatefulWidget {
  const TodoListPg({super.key});

  @override
  State<TodoListPg> createState() => _TodoListPgState();
}

class _TodoListPgState extends State<TodoListPg> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final id = item['_id'];
                  return TodoCard(
                    index: index,
                    item: item,
                    navigateEdit: navigateToEditPage,
                    deleteId: deleteByid,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPg(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPg(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteByid(String id) async {
    //delete item

    //final url = 'http://api.nstack.in/v1/todos/$id';
    //final uri = Uri.parse(url);
    final isSuccess = await TodoService.deletById(id);

    if (isSuccess) {
      //remove item
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage(context, message: 'Unable to delete');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    //final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    //final uri = Uri.parse(url);
    //final response = await http.get(uri);

    if (response != null) {
      //final json = jsonDecode(response.body) as Map;
      //final result = json['items'] as List;
      setState(() {
        items = response;
      });
    } else {
      //error
      showErrorMessage(context, message: 'Unable to fetch');
    }
    setState(() {
      isLoading = false;
    });
  }

  /*void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }*/
}
