import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_todolist/box/boxes.dart';
import 'package:test_todolist/model/todo_model.dart';
import 'package:test_todolist/notification/notification.dart';
import 'package:test_todolist/todo_bloc/todo_bloc.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotification().initNotification();
  }
  @override
  void dispose() {
    Hive.box('todo').close();
    super.dispose();
  }

  void addTodo(String title, String description, bool isDone,DateTime dueDate)  {
    final todo = TodoModel()
      ..title = title
      ..description = description
      ..isDone = isDone
      ..dueDate = dueDate;
    // final box = Boxes.getTodos();
    context.read<TodoBloc>().add(TodoAdded(todo));
    // LocalNotification().showNotification(title: todo.title,body: todo.description ?? 'Nothing');
    // await box.add(todo);
  }

  void showCreateDialog() {
    showDialog(
        context: context,
        builder: (context) => DialogBox(
              onClicked: addTodo,
            ));
  }

  void updateTodo(TodoModel todo, bool isDone,int index) {
    todo.isDone = isDone;
    todo.save();
    context.read<TodoBloc>().add(TodoUpdated(index,isDone));
  }

  void alterTodo(TodoModel todo, String title, String description,int index,DateTime dueDate) {
    todo.title = title;
    todo.description = description;
    todo.dueDate = dueDate;
    todo.save();
    context.read<TodoBloc>().add(TodoAltered(index, todo));

  }

  void deleteTodo(TodoModel todo) {
    // todo.delete();
    context.read<TodoBloc>().add(TodoRemoved(todo));
  }

  Widget buildTodoItem(TodoModel todo,int index) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: Slidable(
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
                      onClicked: (title, description, isDone,dueDate) =>
                          alterTodo(todo, title, description,index,dueDate),
                    ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                    ),
                    Text(
                      todo.description,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const Divider(),
                    Text(todo.dueDate.toString().substring(0,19))
                  ],
                ),
                Checkbox(
                    activeColor: Colors.white54,
                    value: todo.isDone,
                    onChanged: (value) {
                      setState(() {
                        todo.isDone = value!;
                        updateTodo(todo, todo.isDone,index);
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<TodoModel> todos) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return buildTodoItem(
            todos[index],index
          );
        }, separatorBuilder: (BuildContext context, int index) {
          return const Divider(thickness: 0,);
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
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.initial) {
            return const CircularProgressIndicator();
          }
          return ValueListenableBuilder<Box<TodoModel>>(
            valueListenable: Boxes.getTodos().listenable(),
            builder: (BuildContext context, box, Widget? child) {
              final todos = box.values.toList().cast<TodoModel>();
              if (todos.isEmpty) {
                return const Center(child: Text('No data available'));
              }
              return buildContent(todos);
            },
          );
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
