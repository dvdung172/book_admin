import 'package:client/data/models/order.dart';
import 'package:client/data/repositories/orders_repository.dart';
import 'package:client/presentation/views/orders/orders_detail.dart';
import 'package:client/presentation/widgets/CustomCell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable(
      {Key? key, required this.repository, required this.textSearch})
      : super(key: key);
  final OrderRepository repository;
  final String textSearch;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: repository.getAllOrdersWithStream(filter: textSearch),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        print(snapshot.data?.docs);
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong...'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<ProductOrder> data =
              snapshot.data!.docs.map((e) => e.data() as ProductOrder).toList();
          data.sort((a, b) => b.orderDate!.compareTo(a.orderDate!));
          print(data);
          return PaginatedDataTable(
            dataRowHeight: 70,
            source: ProductsSource(
                data: data, context: context, repository: repository),
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Id',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'OrderDate',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'UserName',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Phone',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Address',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Detail',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Total Price',
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
            ],
          );
        }
      },
    );
  }
}

class ProductsSource extends DataTableSource {
  ProductsSource(
      {required this.context, required this.data, required this.repository});

  final BuildContext context;
  final List<ProductOrder> data;
  final OrderRepository repository;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(TextCell('${data[index].id}')),
      DataCell(TextCell('${data[index].orderDate}')),
      DataCell(TextCell(
        '${data[index].name}',
      )),
      DataCell(TextCell(
        '${data[index].phone}',
      )),
      DataCell(TextCell(
        '${data[index].address}',
      )),
      // DataCell(Text('${data[index].item}',overflow: TextOverflow.ellipsis,)),
      DataCell(
        OutlinedButton(
          child: Text('View'),
          onPressed: () {
            SmartDialog.show(
              backDismiss: false,
              clickMaskDismiss: false,
              builder: (_) {
                return OrdersDetail(order: data[index], repository: repository,);
              },
            );
          },
        ),
      ),
      DataCell(Text(
        '${data[index].amount}',
        overflow: TextOverflow.ellipsis,
      )),
      DataCell(Text(
        '${data[index].status}',
        overflow: TextOverflow.ellipsis,
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
