import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/widget/todo-card.dart';

import '../utils/snackBar_helper.dart';

class ToDOListPage extends StatefulWidget {
  const ToDOListPage({Key? key}) : super(key: key);

  @override
  State<ToDOListPage> createState() => _ToDOListPageState();
}
class _ToDOListPageState extends State<ToDOListPage> {
  bool isloading = true;
  List items =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todo App")),
      ),
      body: Visibility(
        visible: isloading,
        child:Center(child: CircularProgressIndicator(),) ,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No Todo Item",
            style: Theme.of(context).textTheme.headlineMedium,),),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context,index){
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return TodoCard(
                  index: index,
                  item: item,
                  navigateEdit: navigateToEdit,
                  deleteById: deleteById);
            },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed:navigate,
          label: Text("Add Todo")),
    );
  }

  Future<void> navigateToEdit(Map item)async{
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage(todo: item,));
    await  Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async{
    final isSuccess = await TodoServices.deleteById(id);
    if(isSuccess){
      // remove item form the list
      final filered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filered;
      });
    }
    else{
      showFailureMessage(context,msg:'Unable to delete');
    }
  }

  Future<void> navigate() async{
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage());
   await  Navigator.push(context, route);
   setState(() {
     isloading = true;
   });
   fetchTodo();
  }

  Future<void> fetchTodo()async {
    final results = await TodoServices.fetchTodos();
    if (results != null) {
      setState(() {
        items = results;
      });
    }
    else{
      showFailureMessage(context,msg: "Something Went Wrong");
  }
    setState(() {
      isloading = false;
    });

  }


}
