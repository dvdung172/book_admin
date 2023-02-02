import 'package:client/core/theme.dart';
import 'package:flutter/material.dart';
import '../../../../core/responsive.dart';
import '../../../../core/style.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                  text: 'Dashboard',
                  size: 30,
                  fontWeight: FontWeight.w800),
              PrimaryText(
                text: 'Bookstore seller',
                size: 16,
                fontWeight: FontWeight.w400,
                color: CustomColor.secondary,
              )
            ]),
      ),
      // Spacer(
      //   flex: 1,
      // ),
      // Expanded(
      //   flex: Responsive.isDesktop(context) ? 1 : 3,
      //   child: TextField(
      //     decoration: InputDecoration(
      //       filled: true,
      //       fillColor: CustomColor.white,
      //       contentPadding:
      //           EdgeInsets.only(left: 40.0, right: 5),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(30),
      //         borderSide: BorderSide(color: CustomColor.white),
      //       ),
      //        focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(30),
      //         borderSide: BorderSide(color: CustomColor.white),
      //       ),
      //       prefixIcon: Icon(Icons.search, color: CustomColor.black),
      //       hintText: 'Search',
      //       hintStyle: TextStyle(color: CustomColor.secondary, fontSize: 14)
      //     ),
      //   ),
      // ),
    ]);
  }
}
