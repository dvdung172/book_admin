import 'package:client/core/responsive.dart';
import 'package:client/core/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';

// class AddDropdownSearch extends StatefulWidget {
//   AddDropdownSearch(
//       {Key? key,
//       required this.title,
//       required this.controller,
//       required this.listData})
//       : super(key: key);
//   final String title;
//   TextEditingController controller;
//   Future<List> listData;
//
//   @override
//   State<AddDropdownSearch> createState() => _AddDropdownSearchState();
// }
//
// class _AddDropdownSearchState extends State<AddDropdownSearch> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(7),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(widget.title, style: CustomTheme.mainTheme.textTheme.headline3),
//           const Padding(
//             padding: EdgeInsets.only(top: 7),
//           ),
//           SizedBox(
//               width: Responsive.isDesktop(context) ? 500 : double.infinity,
//               height: 36,
//               child: TextFieldSearch(
//                 label: '',
//                 controller: widget.controller,
//                 future: () {
//                   return widget.listData;
//                 },
//                 scrollbarDecoration: ScrollbarDecoration(
//                     controller: ScrollController(),
//                     theme: ScrollbarThemeData(
//                         radius: Radius.circular(30.0),
//                         thickness: MaterialStateProperty.all(20.0),
//                         trackColor: MaterialStateProperty.all(Colors.red))),
//                 decoration: const InputDecoration(
//                     filled: true,
//                     fillColor: CustomColor.white,
//                     contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: CustomColor.white),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: CustomColor.black),
//                     ),
//                     hintStyle:
//                         TextStyle(color: CustomColor.secondary, fontSize: 14)),
//               )),
//         ],
//       ),
//     );
//   }
// }
class AddDropdownSearch extends StatelessWidget {
  AddDropdownSearch({Key? key, required this.title, required this.controller, required this.listData}) : super(key: key);
  final String title;
  TextEditingController controller;
  Future<List<String>> listData;

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
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(),
                asyncItems: (filter) {
                  return listData;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
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
                onChanged: (value){
                  controller.text = value!;
                },
                selectedItem: controller.text,
              )),
        ],
      ),
    );
  }
}
