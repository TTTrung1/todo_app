import 'package:hive/hive.dart';
import 'package:test_todolist/model/todo_model.dart';

class Boxes {
  static Box<TodoModel> getTodos() =>
      Hive.box<TodoModel>('todoapp');
}