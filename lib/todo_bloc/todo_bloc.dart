import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_todolist/box/boxes.dart';
import 'package:test_todolist/model/todo_model.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<TodoAdded>(_onAddTodo);
    on<TodoRemoved>(_onRemoveTodo);
    on<TodoUpdated>(_onUpdateTodo);
    on<TodoAltered>(_onAlterTodo);
  }

  void _onStarted(TodoStarted event, Emitter<TodoState> emit) {
    if (state.status == TodoStatus.success) return;
    emit(state.copyWith(
        todos: Boxes.getTodos().values.toList(), status: TodoStatus.success));
  }

  void _onAddTodo(TodoAdded event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      Boxes.getTodos().add(event.todo);
      emit(state.copyWith(
          todos: Boxes.getTodos().values.toList(), status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void _onRemoveTodo(TodoRemoved event, Emitter<TodoState> emit) async {
    final TodoModel todo = event.todo;
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      // Boxes.getTodos().delete(event.todo);
      await todo.delete();
      emit(state.copyWith(
          todos: Boxes.getTodos().values.toList(), status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void _onUpdateTodo(TodoUpdated event, Emitter<TodoState> emit) {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      Boxes.getTodos().values.elementAt(event.index).isDone = event.isDone;
      emit(state.copyWith(
          todos: Boxes.getTodos().values.toList(), status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void _onAlterTodo(TodoAltered event, Emitter<TodoState> emit) {
    final TodoModel todo = event.todo;
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      Boxes.getTodos().values.elementAt(event.index).title = todo.title;
      Boxes.getTodos().values.elementAt(event.index).description = todo.description;
      Boxes.getTodos().values.elementAt(event.index).dueDate = todo.dueDate;
      emit(state.copyWith(
          todos: Boxes.getTodos().values.toList(), status: TodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }
}
