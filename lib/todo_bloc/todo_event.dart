part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoStarted extends TodoEvent {
  @override
  List<Object> get props => [];
}

class TodoAdded extends TodoEvent {
  final TodoModel todo;

  const TodoAdded(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoRemoved extends TodoEvent {
  final TodoModel todo;

  const TodoRemoved(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoUpdated extends TodoEvent {
  final int index;
  final bool isDone;

  const TodoUpdated(this.index,this.isDone);

  @override
  List<Object?> get props => [index];
}

class TodoAltered extends TodoEvent {
  final int index;
  final TodoModel todo;

  const TodoAltered(this.index,this.todo);

  @override
  List<Object?> get props => [index,todo];
}