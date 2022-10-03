import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:max_ecommerce_app/models/models.dart';
import 'package:max_ecommerce_app/repositories/repositories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  StreamSubscription? _categorySubscription;

  CategoryBloc({
    required CategoryRepository categoryRepository,
  })  : _categoryRepository = categoryRepository,
        super(CategoryLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<UpdateCategories>(_onUpdateCategories);
  }

  void _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository.getAllCategories().listen(
          // (categories) => add(
          //   UpdateCategories(categories),
          // ),
          (products) => add(
            UpdateCategories(products),
          ),
        );
  }

  void _onUpdateCategories(
    UpdateCategories event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      CategoryLoaded(
        categories: event.categories,
      ),
    );
  }

  @override
  Future<void> close() {
    _categorySubscription?.cancel();
    return super.close();
  }
}
