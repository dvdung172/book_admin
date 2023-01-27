import 'package:client/core/logger.dart';
import 'package:client/data/models/category.dart';
import 'package:client/data/repositories/categories_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  bool loading = false;
  List<Category> categories = [];

  CategoryProvider(this.categoryRepository);

  void getAllCategories() async {
    loading = true;
    notifyListeners();

    logger.d('getProducts');

    if (categories.isEmpty) {
      // final value = await categoryRepository.getAllCategories();
      loading = false;
      // categories = value;
      notifyListeners();
    }
  }
}
