import 'package:client/presentation/views/categories/categories_form.dart';
import 'package:client/presentation/views/categories/categories_table.dart';
import 'package:flutter/material.dart';

import '../../../core/responsive.dart';
import '../../../core/theme.dart';
import '../../../data/repositories/categories_repository.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryRepository _categoryRepository = CategoryRepository();
  String textSearch = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories',
                      style: CustomTheme.mainTheme.textTheme.headline1),
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? 500
                            : double.infinity,
                        height: 36,
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            hintText: 'Search...',
                          ),
                          onChanged: (text) {
                            setState(() {
                              textSearch = text;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Add'),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  CategoryForm(repository: _categoryRepository,)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            Center(
                child: CategoriesTable(
              repository: _categoryRepository, textSearch: textSearch,
            )),
          ],
        ),
      ),
    );
  }
}
