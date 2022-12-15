import 'package:client/core/responsive.dart';
import 'package:client/core/size_config.dart';
import 'package:client/core/style.dart';
import 'package:client/core/theme.dart';
import 'package:flutter/material.dart';

import 'component/barChart.dart';
import 'component/header.dart';
import 'component/historyTable.dart';
import 'component/infoCard.dart';
import 'component/paymentDetailList.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

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
                              icon: 'assets/icon/credit-card.svg',
                              label: 'Transafer via \nCard number',
                              amount: '\$1200'),
                          InfoCard(
                              icon: 'assets/icon/transfer.svg',
                              label: 'Transafer via \nOnline Banks',
                              amount: '\$150'),
                          InfoCard(
                              icon: 'assets/icon/bank.svg',
                              label: 'Transafer \nSame Bank',
                              amount: '\$1500'),
                          InfoCard(
                              icon: 'assets/icon/invoice.svg',
                              label: 'Transafer to \nOther Bank',
                              amount: '\$1500'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: 'Balance',
                              size: 16,
                              fontWeight: FontWeight.w400,
                              color: CustomColor.secondary,
                            ),
                            PrimaryText(
                                text: '\$1500',
                                size: 30,
                                fontWeight: FontWeight.w800),
                          ],
                        ),
                        PrimaryText(
                          text: 'Past 30 DAYS',
                          size: 16,
                          fontWeight: FontWeight.w400,
                          color: CustomColor.secondary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    Container(
                      height: 180,
                      child: BarChartCopmponent(),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                            text: 'History',
                            size: 30,
                            fontWeight: FontWeight.w800),
                        PrimaryText(
                          text: 'Transaction of lat 6 month',
                          size: 16,
                          fontWeight: FontWeight.w400,
                          color: CustomColor.secondary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    HistoryTable(),
                    if (!Responsive.isDesktop(context)) PaymentDetailList()
                  ],
                ),
              ),
            )),
        if (Responsive.isDesktop(context))
          Expanded(
            flex: 4,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: SizeConfig.screenHeight,
                decoration: BoxDecoration(color: CustomColor.secondaryBg),
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: PaymentDetailList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
