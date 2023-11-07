import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_todolist/todo_bloc/todo_bloc.dart';

import 'home_screen.dart';
import 'model/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todo');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.greenAccent,
          canvasColor: Colors.green,
          textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              displayLarge:
              TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              displayMedium:
              TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              displaySmall:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
      home: BlocProvider(
        create: (context) => TodoBloc()..add(TodoStarted()),
        child: MyHomePage(),
      ),
    );
  }
}
