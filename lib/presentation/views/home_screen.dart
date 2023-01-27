import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:client/presentation/views/categories/categories.dart';
import 'package:client/presentation/views/dashboard/dashboard.dart';
import 'package:client/presentation/views/products/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard/component/appBarActionItems.dart';
import 'dashboard/component/barChart.dart';
import 'dashboard/component/header.dart';
import 'dashboard/component/historyTable.dart';
import 'dashboard/component/infoCard.dart';
import 'dashboard/component/paymentDetailList.dart';
import 'sideMenu.dart';
import '../../core/responsive.dart';
import '../../core/size_config.dart';
import '../../core/style.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  HomeScreen({Key? key}) : super(key: key) {
    _tabList = <Widget>[
      const DashBoard(key: ValueKey(0)),
      const Categories(key: ValueKey(2)),
      const Products(key: ValueKey(1)),
    ];
  }

  late final List<Widget> _tabList;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SideBarProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.white,
        leading: IconButton(
            onPressed: () {
              _drawerKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu, color: CustomColor.black)),
        actions: [
          AppBarActionItems(),
        ],
      ),
      body: _tabList[provider.currentIndex],

    );
  }
}
