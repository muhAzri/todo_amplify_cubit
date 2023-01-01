// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/models/ModelProvider.dart';
import 'package:todo/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final rep = TodoRepository();
  TodoCubit() : super(TodosLoading());

  void getTodos() async {
    if (state is TodoSuccess == false) {
      emit(TodosLoading());
    }

    try {
      final todos = await rep.getTodos();
      emit(TodoSuccess(todos));
    } catch (e) {
      rethrow;
    }
  }

  void createTodo(String title) async {
    await rep.createTodo(title);
    getTodos();
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    await rep.updateTodoIsComplete(todo, isComplete);
    getTodos();
  }
}
