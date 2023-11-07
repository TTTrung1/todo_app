import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_todolist/model/todo_model.dart';

import '../notification/notification.dart';
import '../todo_bloc/todo_bloc.dart';

class DialogBox extends StatefulWidget {
  TodoModel? todoItem;
  Function(String title, String description, bool isDone) onClicked;

  DialogBox({super.key, this.todoItem, required this.onClicked});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  List<TodoModel> listTd = [];

  @override
  void initState() {
    super.initState();
    if (widget.todoItem != null) {
      titleTEC.text = widget.todoItem!.title;
      descriptionTEC.text = widget.todoItem!.description;
    }
  }

  @override
  void dispose() {
    titleTEC.dispose();
    descriptionTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todoItem != null;
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          content: Container(
            padding: const EdgeInsets.all(10),
            height: 200,
            child: Column(
              children: [
                Text(
                  'Add a todo',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                TextField(
                  controller: titleTEC,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(hintText: 'Title of todo'),
                ),
                TextField(
                  controller: descriptionTEC,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: titleTEC.text.isEmpty ? null : () {
                          final title = titleTEC.text;
                          final description = descriptionTEC.text;
                          widget.onClicked(
                              title,
                              description,
                              widget.todoItem != null
                                  ? widget.todoItem!.isDone
                                  : false);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          isEdit ? 'Edit' : 'Add',
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 20),
                        )),
                    TextButton(
                        onPressed: () {
                          titleTEC.clear();
                          descriptionTEC.clear();
                          Navigator.of(context).pop('Cancel');
                          LocalNotification().showNotification(title: 'Hello',body: 'Noti');
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 20),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
