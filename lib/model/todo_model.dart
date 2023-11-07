import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject{
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late bool isDone = false;
}

// class TodoModel{
//   final String title;
//   final String description;
//   bool isDone;
//
//   TodoModel({required this.title, this.description = '',this.isDone = false});
//
//   factory TodoModel.fromJson(Map<String,dynamic> data){
//     final title = data['title'] as String;
//     final description = data['description'] as String;
//     final isDone = data['isDone'] as bool;
//     return TodoModel(title: title, description: description,isDone: isDone);
//   }
//   Map<String,dynamic> toJson(){
//     return {
//       'title': title,
//       'description': description,
//       'isDone': isDone
//     };
//   }
// }