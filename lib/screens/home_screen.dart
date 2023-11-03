import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/todo.dart';
import '../todo_bloc/todo_bloc.dart';
import '../todo_bloc/todo_event.dart';
import '../todo_bloc/todo_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
      AddTodo(todo),
    );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
      RemoveTodo(todo),
    );
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(
        AlterTodo(index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white60,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller1 = TextEditingController();
                  TextEditingController controller2 = TextEditingController();
                  return AlertDialog(
                    title:Text(
                      'Add a Task',
                      style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: controller1,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller2,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MaterialButton(
                          onPressed: () {
                            addTodo(
                              Todo(
                                  title: controller1.text,
                                  subtitle: controller2.text
                              ),
                            );
                            controller1.text = '';
                            controller2.text = '';
                            Navigator.pop(context);
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Done",
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });

          },
          backgroundColor: Colors.green,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text(
            'ToDo App',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if(state.status == TodoStatus.success) {
                return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, int i) {
                      return Card(
                        color: Colors.white,
                        elevation: 0.4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    removeTodo(state.todos[i]);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                                title: Text(
                                    state.todos[i].title,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                subtitle: Text(
                                    state.todos[i].subtitle,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                trailing: Checkbox(
                                    value: state.todos[i].isDone,
                                    activeColor: Theme.of(context).colorScheme.secondary,
                                    onChanged: (value) {
                                      alertTodo(i);
                                    }
                                )
                            )
                        ),
                      );
                    }
                );
              } else if (state.status == TodoStatus.initial){
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container();
              }
            },
          ),
        )
    );
  }
}
