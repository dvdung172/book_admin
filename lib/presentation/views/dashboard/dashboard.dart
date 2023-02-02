import 'package:client/core/responsive.dart';
import 'package:client/core/size_config.dart';
import 'package:client/core/style.dart';
import 'package:client/core/theme.dart';
import 'package:client/data/repositories/customers_repository.dart';
import 'package:client/data/repositories/orders_repository.dart';
import 'package:client/data/repositories/products_repository.dart';
import 'package:flutter/material.dart';

import 'component/barChart.dart';
import 'component/header.dart';
import 'component/historyTable.dart';
import 'component/infoCard.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var customerCount = 0;
  var productCount = 0;
  var orderCount = 0;
  var avgSaleCount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrderRepository().countCollecion().then((value) => setState(() {
      orderCount = value;
      OrderRepository().sumOrder().then((value) => setState(() { avgSaleCount = value/orderCount; }) );
    }) );
    ProductRepository().countCollecion().then((value) => setState(() { productCount = value; }) );
    CustomerRepository().countCollecion().then((value) => setState(() { customerCount = value; }) );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 10,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          InfoCard(
                              icon: 'assets/icon/customer.svg',
                              label: 'Customer',
                              amount: '${customerCount}'),
                          InfoCard(
                              icon: 'assets/icon/invoice.svg',
                              label: 'Order',
                              amount: '${orderCount}'),
                          InfoCard(
                              icon: 'assets/icon/book.svg',
                              label: 'Product',
                              amount: '${productCount}'),
                          InfoCard(
                              icon: 'assets/icon/salary.svg',
                              label: 'Average Sale',
                              amount: '${avgSaleCount}'),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 4,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         PrimaryText(
                    //           text: 'Balance',
                    //           size: 16,
                    //           fontWeight: FontWeight.w400,
                    //           color: CustomColor.secondary,
                    //         ),
                    //         PrimaryText(
                    //             text: '\$1500',
                    //             size: 30,
                    //             fontWeight: FontWeight.w800),
                    //       ],
                    //     ),
                    //     PrimaryText(
                    //       text: 'Past 30 DAYS',
                    //       size: 16,
                    //       fontWeight: FontWeight.w400,
                    //       color: CustomColor.secondary,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 3,
                    // ),
                    // Container(
                    //   height: 180,
                    //   child: BarChartCopmponent(),
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 5,
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     PrimaryText(
                    //         text: 'History',
                    //         size: 30,
                    //         fontWeight: FontWeight.w800),
                    //     PrimaryText(
                    //       text: 'Transaction of lat 6 month',
                    //       size: 16,
                    //       fontWeight: FontWeight.w400,
                    //       color: CustomColor.secondary,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 3,
                    // ),
                    // HistoryTable(),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
