part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodoState {}

class TodosFailed extends TodoState {
  final String e;

  const TodosFailed(this.e);

  @override
  List<Object> get props => [e];
}

class TodoSuccess extends TodoState {
  final List<Todo> todos;

  const TodoSuccess(this.todos);

  @override
  List<Object> get props => [todos];
}
