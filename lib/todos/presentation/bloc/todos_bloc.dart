import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/todos_repository.dart';
import 'todos_event.dart';
import 'todos_states.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final todosRepository = TodosRepositoryFake();

  TodosBloc() : super(const TodosInitial()) {
    on<AddTodo>(_onCreateTodos);
    on<ShowTodos>(_onShowTodos);
    on<RemoveTodo>(_onDeleteTodos);
    on<UpdateTodo>(_onUpdateTodos);
  }

  _onCreateTodos(AddTodo event, emit) {
    emit(TodosLoaded(todos: todosRepository.addTodos(event.todo)));
  }

  _onDeleteTodos(RemoveTodo event, emit) {
    emit(TodosLoaded(todos: todosRepository.deleteTodos(event.todo)));
  }

  _onUpdateTodos(UpdateTodo event, emit) {
    emit(TodosLoaded( todos: todosRepository.updateTodos(event.todo, event.title)));
  }

   _onShowTodos(ShowTodos event, emit) {
    emit(TodosLoaded(todos: todosRepository.showTodos()));
  }
}

  // Future<void> _onCreateTodos(event, emit) async {
  //   emit(const TodosLoading());
  //   try {
  //     final todos = todosRepository.addTodos(event.todo);
  //     emit(TodosLoaded(todos: todos));
  //   } catch (e) {
  //     emit(TodosException(e.toString()));
  //   }
  // }

  //  Future<void> _onDeleteTodos(event, emit) async {
  //   emit(const TodosLoading());
  //   try {
  //     final todos = todosRepository.deleteTodos(event.todo);
  //     emit(TodosLoaded(todos: todos));
  //   } catch (error) {
  //     emit(TodosException(error.toString()));
  //   }
  // }

  //  Future<void> _onShowTodos(event, emit) async {
  //   emit(const TodosLoading());
  //   try {
  //     final todos = todosRepository.showTodos(event.todo);
  //     emit(TodosLoaded(todos: todos));
  //   } catch (error) {
  //     emit(TodosException(error.toString()));
  //   }
  // }