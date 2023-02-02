import 'package:client/core/responsive.dart';
import 'package:client/core/theme.dart';
import 'package:client/data/models/order.dart';
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/orders_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class OrdersDetail extends StatefulWidget {
  const OrdersDetail({Key? key, required this.order, required this.repository})
      : super(key: key);
  final ProductOrder order;
  final OrderRepository repository;

  @override
  State<OrdersDetail> createState() => _OrdersDetailState();
}

class _OrdersDetailState extends State<OrdersDetail> {
  ProductOrder get order => widget.order;
  OrderRepository get repository => widget.repository;
  var status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = order.status!;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: 1000,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Orderdetail: #...',
                        style: CustomTheme.mainTheme.textTheme.headline1),
                    IconButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                        },
                        icon: const Icon(Icons.exit_to_app))
                  ],
                ),
                Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 40, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Name: ",
                                  style:
                                  CustomTheme.mainTheme.textTheme.headline3),
                              Text("${order.name}"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                          ),
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text("Address: ",
                                    maxLines: 3,
                                    style: CustomTheme.mainTheme.textTheme.headline3),
                              ),
                              Text("${order.address}"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                          ),
                          Row(
                            children: [
                              Text("Phone: ",
                                  style:
                                  CustomTheme.mainTheme.textTheme.headline3),
                              Text("${order.phone}"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                          ),
                          Row(
                            children: [
                              Text("Email: ",
                                  style:
                                  CustomTheme.mainTheme.textTheme.headline3),
                              Text("${order.email}"),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Order at: ",
                                  style: CustomTheme.mainTheme.textTheme.headline3),
                              Text("${order.orderDate}"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                          ),
                          Row(
                            children: [
                              Text("Status: ",
                                  style: CustomTheme.mainTheme.textTheme.headline3),
                              dropdownButton(value: status, id: order.id!),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                ),
                Text("Order Summary",
                    style: CustomTheme.mainTheme.textTheme.headline2),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: MyStatelessWidget(
                        data: order.item!,
                        repository: repository,
                      )),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total: ',
                        style: CustomTheme.mainTheme.textTheme.headline5),
                    Text('${NumberFormat('###,###').format(order.amount)} ',style: CustomTheme.mainTheme.textTheme.headline1),
                    Text('đồng',style: CustomTheme.mainTheme.textTheme.headline5),
                    const Padding(
                      padding: EdgeInsets.only(right: 36),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    //imitate widget
    dropdownButton({required String id, required String value}) {
      return DropdownButton<String>(
        value: value,
        items: [
          DropdownMenuItem(value: 'Complited', child: Text('Complited')),
          DropdownMenuItem(value: 'Progress', child: Text('Progress')),
          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
          DropdownMenuItem(value: 'Cancle', child: Text('Cancle')),
        ],
        onChanged: (value) async {
         await repository.updateStatus(id: id, value: value!);
         setState(() {
           status = value;
         });
        },
      );
    }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget(
      {super.key, required this.data, required this.repository});

  final List<Item> data;
  final OrderRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repository.getOrderSummary(data: data),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong...'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Product Name',
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
                    'Quantity',
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
            ],
            rows: <DataRow>[
              for (var item in snapshot.data!)
                DataRow(
                  cells: <DataCell>[
                    DataCell(ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text('${item['product'].name}',maxLines: 4,
                          overflow: TextOverflow.ellipsis,))),
                    DataCell(Container(
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 200,
                          minHeight: 150,
                          maxHeight: 300),
                      child: (item['product'].image != '' &&
                              item['product'].image != null)
                          ? Image(
                              image: NetworkImage('${item['product'].image}'))
                          : Image.asset("assets/image/img.png"),
                    )),
                    DataCell(Text('${item['quantity']}')),
                    DataCell(
                        Text('${NumberFormat('###,###').format(item['product'].price * item['quantity'])}')),
                  ],
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
