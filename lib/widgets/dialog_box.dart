import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_todolist/model/todo_model.dart';

import '../notification/notification.dart';
import '../todo_bloc/todo_bloc.dart';

class DialogBox extends StatefulWidget {
  TodoModel? todoItem;
  Function(String title, String description, bool isDone,DateTime dueDate) onClicked;

  DialogBox({super.key, this.todoItem, required this.onClicked});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  List<TodoModel> listTd = [];
  final now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateTime datePicked = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.todoItem != null) {
      titleTEC.text = widget.todoItem!.title;
      descriptionTEC.text = widget.todoItem!.description;
      datePicked = widget.todoItem!.dueDate;
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
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          content: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add a todo',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: titleTEC,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                      hintText: 'Title of todo'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descriptionTEC,
                  decoration: const InputDecoration(
                      hintText: 'Description'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(datePicked.toString().substring(0,19)),
                    IconButton(onPressed: () async{
                      selectedDate = await showDatePicker(
                        initialDate: selectedDate!,
                        firstDate: now,
                        lastDate: DateTime(now.year + 2),
                        context: context,
                      );
                      if(selectedDate != null) {
                        setState(() {
                          datePicked = selectedDate!;
                        });
                      }
                    },
                        icon: const Icon(Icons.date_range))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: titleTEC.text.isEmpty
                            ? null
                            : () {
                          final title = titleTEC.text;
                          final description = descriptionTEC.text;
                          final pickedDate = datePicked;
                          widget.onClicked(
                              title,
                              description,
                              widget.todoItem != null
                                  ? widget.todoItem!.isDone
                                  : false,
                          pickedDate);
                          Navigator.of(context).pop();
                          LocalNotification().showNotification(
                              title: title, body: description);
                        },
                        child: Text(
                          isEdit ? 'Edit' : 'Add',
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .canvasColor,
                              fontSize: 20),
                        )),
                    TextButton(
                        onPressed: () {
                          titleTEC.clear();
                          descriptionTEC.clear();
                          Navigator.of(context).pop('Cancel');
                          LocalNotification()
                              .showNotification(
                              title: 'Hello', body: 'Noti');
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .canvasColor,
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
