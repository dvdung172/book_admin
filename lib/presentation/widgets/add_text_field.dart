import 'package:client/core/responsive.dart';
import 'package:client/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTextField extends StatelessWidget {
  AddTextField({Key? key, required this.title,required this.controller,this.inputType,this.inputFormater})
      : super(key: key);
  final String title;
  TextEditingController controller;
  TextInputType? inputType;
  List<TextInputFormatter>? inputFormater;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CustomTheme.mainTheme.textTheme.headline3),
          const Padding(
            padding: EdgeInsets.only(top: 7),
          ),
          SizedBox(
            width: Responsive.isDesktop(context) ? 500 : double.infinity,
            height: 36,
            child: TextField(
              keyboardType: inputType,
              inputFormatters: inputFormater,
              controller: controller,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: CustomColor.white,
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColor.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColor.black),
                  ),
                  hintStyle:
                      TextStyle(color: CustomColor.secondary, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
