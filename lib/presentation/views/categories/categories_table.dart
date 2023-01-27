import 'dart:math';

import 'package:client/data/models/category.dart';
import 'package:client/data/repositories/categories_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesTable extends StatelessWidget {
  const CategoriesTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoryRepository _categoryRepository = CategoryRepository();
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _categoryRepository.getAllCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>>snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {;
          List<Category> data = snapshot.data!.map((e) => e.data() as Category).toList();
          return PaginatedDataTable(
            source: CategoriesSource(data: data),
            columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  'STT',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Image',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'CreatedAt',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Action',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );

  }
}
class CategoriesSource extends DataTableSource{
  CategoriesSource({required this.data});
  final List<Category> data;
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(Text('${index}')),
      DataCell(Image.network('${data[index].image}')),
      DataCell(Text('${data[index].name}')),
      DataCell(Text('${data[index].createdAt}')),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.edit_note_sharp),
            onPressed: () {},
          ),
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.delete, color: Colors.red,),
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}
