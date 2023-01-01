import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/loading_page.dart';
import 'package:todo/shared/methods.dart';

import '../cubit/todo_cubit.dart';
import '../models/Todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navBar(),
      floatingActionButton: _floatingActionButton(),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoSuccess) {
            return state.todos.isEmpty
                ? _emptyTodosView()
                : todoListView(state.todos);
          } else if (state is TodosFailed) {
            showCustomSnackbar(context, state.e);
          }
          return const LoadingPage();
        },
      ),
    );
  }

  Widget todoListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isCompleted,
            onChanged: (newValue) {
              BlocProvider.of<TodoCubit>(context)
                  .updateTodoIsComplete(todo, newValue!);
            },
          ),
        );
      },
    );
  }

  AppBar _navBar() {
    return AppBar(
      title: const Text('Todos'),
    );
  }

  Widget addTodo() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: "Enter title"),
            controller: titleController,
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                BlocProvider.of<TodoCubit>(context)
                    .createTodo(titleController.text);
                titleController.text = '';
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add Todo"),
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(context: context, builder: (context) => addTodo());
      },
    );
  }

  Widget _emptyTodosView() {
    return const Center(
      child: Text('No todos yet'),
    );
  }
}
