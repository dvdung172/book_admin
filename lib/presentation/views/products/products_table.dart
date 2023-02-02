
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/CustomCell.dart';
import 'products_form.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({Key? key, required this.repository, required this.textSearch}) : super(key: key);
  final ProductRepository repository;
  final String textSearch;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: repository.getAllProductsWithStream(filter: textSearch),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong...'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else
        {
          List<Product> data = snapshot.data!.docs.map((e) => e.data() as Product).toList();
          data.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return PaginatedDataTable(
            dataRowHeight: 70,
            source: ProductsSource(data: data, context: context, repository: repository),
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
                    'Author',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Category',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Publisher',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Price',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Stock',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Description',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Active',
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
            ],
          );
        }

      },
    );
  }
}

class ProductsSource extends DataTableSource {
  ProductsSource({required this.context,required this.data,required this.repository});
  final BuildContext context;
  final List<Product> data;
  final ProductRepository repository;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(TextCell('$index')),
      DataCell(Container(
        padding: EdgeInsets.all(5),
        constraints: const BoxConstraints(
            minWidth: 100, maxWidth: 200, minHeight: 150, maxHeight: 300),
        child: (data[index].image != '' && data[index].image != null)
            ? Image(image: NetworkImage('${data[index].image}'))
            : Image.asset("assets/image/img.png"),
      )),
      DataCell(TextCell('${data[index].name}')),
      DataCell(TextCell('${data[index].author}')),
      DataCell(TextCell('${data[index].category}',)),
      DataCell(TextCell('${data[index].publisher}',)),
      DataCell(TextCell('${data[index].price}',)),
      DataCell(TextCell('${data[index].stock}',)),
      DataCell(Container(
          constraints: const BoxConstraints(
              minWidth: 150, maxWidth: 300),
          child: Text('${data[index].description}', overflow: TextOverflow.ellipsis,))),

      DataCell(Switch(
        value: data[index].isActived,
        activeColor: Colors.blue,
        onChanged: (bool value) async {
          await repository.isActivedProduct(id: data[index].id!, value: value);
        },
      ),),
      DataCell(Text('${data[index].createdAt}')),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.edit_note_sharp),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  ProductsForm(repository: repository, product: data[index])));
            },
          ),
          IconButton(
            splashRadius: 17,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (value) =>  CupertinoAlertDialog(
                    title:  Text("Delete Item"),
                    content:  Text("Are you sure you want delete this item?"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text("Yes"),
                        onPressed: () async {
                          await repository.deleteProduct(id: data[index].id!);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text("No"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
              );
            },
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
