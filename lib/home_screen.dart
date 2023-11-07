import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_todolist/box/boxes.dart';
import 'package:test_todolist/model/todo_model.dart';
import 'package:test_todolist/widgets/dialog_box.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  void dispose() {
    Hive.box('todo').close();
    super.dispose();
  }

  Future addTodo(String title, String description, bool isDone) async {
    final todo = TodoModel()
      ..title = title
      ..description = description
      ..isDone = isDone;
    final box = Boxes.getTodos();
    await box.add(todo);
  }

  void showCreateDialog() {
    showDialog(
        context: context,
        builder: (context) => DialogBox(
              onClicked: addTodo,
            ));
  }

  Future<void> updateTodo(
      TodoModel todo, String title, String description, bool isDone) async {
    todo.title = title;
    todo.description = description;
    todo.isDone = isDone;
    await todo.save();
  }

  void deleteTodo(TodoModel todo) {
    todo.delete();
  }

  Widget buildTodoItem(TodoModel todo) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteTodo(todo),
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
          )
        ],
      ),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => DialogBox(
                    todoItem: todo,
                    onClicked: (title,description,isDone) => updateTodo(todo,title,description,isDone),
                  ));
        },
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Checkbox(
                  activeColor: Colors.white54,
                  value: todo.isDone,
                  onChanged: (value) {
                    setState(() {
                      todo.isDone = value!;
                      updateTodo(todo, todo.title, todo.description, todo.isDone);
                    });
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  Text(
                    todo.description,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<TodoModel> todos) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return buildTodoItem(todos[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Center(
            child:
                Text('TO DO', style: Theme.of(context).textTheme.titleLarge)),
        elevation: 0,
      ),
      body: ValueListenableBuilder<Box<TodoModel>>(
        valueListenable: Boxes.getTodos().listenable(),
        builder: (BuildContext context, box, Widget? child) {
          final todos = box.values.toList().cast<TodoModel>();
          return buildContent(todos);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        onPressed: showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
