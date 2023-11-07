part of 'todo_bloc.dart';

enum TodoStatus {initial,loading,error,success}

class TodoState extends Equatable {

  final List<TodoModel> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const <TodoModel>[],
    this.status = TodoStatus.initial
  });

  TodoState copyWith({
    TodoStatus? status,
    List<TodoModel>? todos,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [todos,status];
}



