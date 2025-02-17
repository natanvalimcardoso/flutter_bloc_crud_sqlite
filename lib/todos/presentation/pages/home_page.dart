import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_2/todos/datasource/datasource.dart';

import '../../domain/model/todos_model.dart';
import '../bloc/todos_bloc.dart';
import '../bloc/todos_event.dart';
import '../bloc/todos_states.dart';
import '../repository/todos_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textControllerEdit = TextEditingController();
  TodosRepositoryFake todosRepository = TodosRepositoryFake();

  final TodosBloc bloc = TodosBloc()..add(ShowTodos());

  late Datasource datasource;
  List docs = [];

  iniciar(){ //serve para iniciar o banco de dados
    datasource = Datasource();
    datasource.initiliase(); // puxa la da datasource
    datasource.read().then((value) => {
      setState((){
        docs = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                setState(() {
                  // addTodo(title: _textController.text);
                  bloc.add(
                      AddTodo(todo: TodosModel(title: _textController.text)));
                });
                _textController.clear();
              }
            },
            child: const Text('Adicionar'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 400,
            child: BlocBuilder<TodosBloc, TodosState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is TodosLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TodosLoaded) {
                  final todosList = state.todos;
                  return ListView.builder(
                    itemCount: todosList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(todosList[index].title),
                          trailing: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              bloc.add(RemoveTodo(todo: todosList[index]));
                            });
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _textControllerEdit,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        bloc.add(
                                          UpdateTodo(
                                              title: _textControllerEdit.text,
                                              todo: todosList[index]),
                                        );
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text('Adicionar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Lista está vazia'));
              },
            ),
          )
        ],
      ),
    );
  }
}
  
