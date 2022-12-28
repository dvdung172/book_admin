import 'dart:math';

import 'package:flutter/material.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(columns: const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'ID',
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
            'Price',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Quantity',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Sub Category',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Created',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Status',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Product Detail',
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
    ], source: ProductSource());
  }
}
class ProductSource extends DataTableSource{

  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "id": index,
        "title": "Item $index",
        "price": Random().nextInt(10000)
      });
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(Text('${index}')),
      DataCell(Image.network('https://picsum.photos/250?image=9')),
      DataCell(Text('Harry Porter')),
      DataCell(Text("\$200")),
      DataCell(Text('50')),
      DataCell(Text('Trinh thám')),
      DataCell(Text('20/12/2022')),
      DataCell(
        Switch(
          value: true,
          activeColor: Colors.blue,
          onChanged: (bool value) {},
        ),
      ),
      DataCell(
        OutlinedButton(
          child: Text('View'),
          onPressed: () {
            print('Hello');
          },
        ),
      ),
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
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
  
}
