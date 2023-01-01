import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/todo_cubit.dart';
import 'package:todo/pages/loading_page.dart';
import 'package:todo/pages/todo_page.dart';
import 'package:amplify_api/amplify_api.dart';

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoCubit()..getTodos(),
        child: _amplifyConfigured ? const TodoPage() : const LoadingPage(),
      ),
    );
  }

  void _configureAmplify() async {
    // Once Plugins are added, configure Amplify
    try {
      Future.wait([
        Amplify.addPlugin(
            AmplifyDataStore(modelProvider: ModelProvider.instance)),
        Amplify.addPlugin(AmplifyAPI())
      ]);
      await Amplify.configure(amplifyconfig);

      setState(
        () {
          _amplifyConfigured = true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
