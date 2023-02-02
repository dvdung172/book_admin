import 'package:client/data/models/customer.dart';
import 'package:client/data/repositories/customers_repository.dart';
import 'package:client/data/repositories/orders_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../core/theme.dart';
import '../../widgets/CustomCell.dart';
import '../orders/orders_detail.dart';
import 'customers_form.dart';

class CustomersTable extends StatelessWidget {
  const CustomersTable(
      {Key? key, required this.repository, required this.textSearch})
      : super(key: key);
  final CustomerRepository repository;
  final String textSearch;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: repository.getAllCustomersWithStream(filter: textSearch),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong...'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<Customer> data =
              snapshot.data!.docs.map((e) => e.data() as Customer).toList();
          data.sort((a, b) => b.registerDate!.compareTo(a.registerDate!));
          return PaginatedDataTable(
            dataRowHeight: 70,
            source: CustomersSource(
                data: data, context: context, repository: repository),
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
                    'Email',
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
                    'Orders',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Register Date',
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

class CustomersSource extends DataTableSource {
  CustomersSource(
      {required this.context, required this.data, required this.repository});

  final BuildContext context;
  final List<Customer> data;
  final CustomerRepository repository;

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
      DataCell(TextCell('${data[index].email}')),
      DataCell(TextCell(
        '${data[index].phone}',
      )),
      DataCell(TextCell(
        '${data[index].address}',
      )),
      DataCell(
        OutlinedButton(
          child: Text('View'),
          onPressed: () async {
            var _list = await OrderRepository().getOrderbyUser(uId: data[index].id!);
            if(_list.length <=0){
              EasyLoading.showError("No Order yet!");
            } else{
              SmartDialog.show(
                backDismiss: false,
                clickMaskDismiss: false,
                builder: (_) {
                  return Container(
                    height: 480,
                    width: 600,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select Order',
                                style: CustomTheme.mainTheme.textTheme.headline3),
                            IconButton(
                                onPressed: () {
                                  SmartDialog.dismiss();
                                },
                                icon: const Icon(Icons.exit_to_app))
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: [
                                DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Id',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Date',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    for (var item in _list)
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(TextButton(
                                              onPressed: () {
                                                SmartDialog.dismiss();
                                                SmartDialog.show(
                                                  backDismiss: false,
                                                  clickMaskDismiss: false,
                                                  builder: (_) {
                                                    return OrdersDetail(order: item, repository: OrderRepository(),);
                                                  },
                                                );
                                              },
                                              child: TextCell('${item.id}'))),
                                          DataCell(TextCell('${item.orderDate}')),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      DataCell(Text('${data[index].registerDate}')),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.edit_note_sharp),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomersForm(
                          repository: repository, customer: data[index])));
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
                  builder: (value) => CupertinoAlertDialog(
                        title: Text("Delete Item"),
                        content:
                            Text("Are you sure you want delete this item?"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Yes"),
                            onPressed: () async {
                              await repository.deleteCustomer(
                                  id: data[index].id!);
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
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
