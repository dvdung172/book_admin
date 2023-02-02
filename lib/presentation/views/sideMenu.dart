import 'package:client/core/di.dart';
import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/size_config.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = sl<SideBarProvider>();
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(color: CustomColor.secondaryBg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                alignment: Alignment.topCenter,
                width: double.infinity,
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 35,
                  height: 20,
                  child: SvgPicture.asset('assets/icon/mac-action.svg'),
                ),
              ),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/home.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Home",
                  onPressed: () {
                    provider.currentIndex = 0;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/clipboard.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Categories",
                  onPressed: () {
                    provider.currentIndex = 1;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/author.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Authors",
                  onPressed: () {
                    provider.currentIndex = 2;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/bank.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Publishers",
                  onPressed: () {
                    provider.currentIndex = 3;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/book.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Products",
                  onPressed: () {
                    provider.currentIndex = 4;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/invoice.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Orders",
                  onPressed: () {
                    provider.currentIndex = 5;
                    Navigator.pop(context);
                  }),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/icon/customer.svg',
                    color: CustomColor.iconGray,
                  ),
                  tooltip: "Customers",
                  onPressed: () {
                    provider.currentIndex = 6;
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
