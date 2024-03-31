import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/models/todo_model.dart';
import 'package:provider/provider.dart';

import 'controller/loading_provider.dart';
import 'controller/todo_controller.dart';
import 'widgets/custom_button.dart';
import 'widgets/no_tasks_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPressed = false;
  bool isValidForm = false;
  final taskController = TextEditingController();

  showForm() {
    setState(() {
      if (taskController.text.isEmpty && isPressed) {
        isPressed = false;
      } else {
        taskController.clear();
        isValidForm = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoController>(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: todoController,
        builder: (BuildContext context, Widget? child) {
          return todoController.todos.isEmpty
              ? const NoTasksWidget()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: size.height * 0.12,
                      collapsedHeight: size.height * 0.12,
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, top: 32, right: 16, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text(
                                  'Todays\' Tasks',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: todoController.deleteAllTodos,
                                  child: Text(
                                    'CLEAR ALL',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '(${todoController.numberTodosCompleted}/${todoController.todos.length}) Completed Tasks',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListenableBuilder(
                      listenable: todoController,
                      builder: (BuildContext context, Widget? child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final todo = todoController.todos[index];
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.only(right: 16),
                                minVerticalPadding: 20,
                                leading: Checkbox(
                                  value: todo.completed,
                                  onChanged: (value) {
                                    todoController.updateTodo(
                                      todo.id!,
                                      value!,
                                    );
                                  },
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent.withOpacity(0.2),
                                  ),
                                  width: 40,
                                  child: IconButton(
                                    onPressed: () =>
                                        todoController.deleteTodo(todo.id!),
                                    icon: const Icon(
                                      Icons.delete_outline_sharp,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    color: todo.completed
                                        ? Colors.grey.shade400
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            childCount: todoController.todos.length,
                          ),
                        );
                      },
                    ),
                  ],
                );
        },
      ),
      bottomSheet: Visibility(
        visible: isPressed,
        child: BottomAppBar(
          surfaceTintColor: Colors.white,
          height: MediaQuery.sizeOf(context).height * 0.18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      isValidForm = true;
                    } else {
                      isValidForm = false;
                    }
                  });
                },
                controller: taskController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Add new task...',
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: showForm,
                    icon: const Icon(
                      Icons.close_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Consumer<LoadingProvider>(
                  builder: (context, loadingProvider, child) {
                return CustomButton(
                  isLoading: loadingProvider.isLoading,
                  label: 'ADD TASK',
                  onPressed: isValidForm
                      ? () async {
                          await todoController
                              .addTodos(
                                TodoModel(
                                  title: taskController.text,
                                  createdAt: DateTime.now(),
                                ),
                              )
                              .whenComplete(
                                () => setState(
                                  () {
                                    taskController.clear();
                                    isPressed = false;
                                  },
                                ),
                              );
                        }
                      : null,
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !isPressed,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              isPressed = !isPressed;
            });
          },
          tooltip: 'Increment',
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
