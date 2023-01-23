import 'dart:io';

import 'package:client/core/responsive.dart';
import 'package:client/presentation/widgets/add_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../dashboard/component/appBarActionItems.dart';
import '../sideMenu.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _image;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: CustomColor.black)),
        actions: [
          AppBarActionItems(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Product',
                  style: CustomTheme.mainTheme.textTheme.headline1),
              const Padding(
                padding: EdgeInsets.only(top: 21),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            AddTextField(title: 'Title'),
                            AddTextField(title: 'Price'),
                            AddTextField(title: 'SubCategory'),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 34),
                        ),
                        Column(
                          children: [
                            AddTextField(title: 'SubTitle'),
                            AddTextField(title: 'Quantity'),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description",
                              style: CustomTheme.mainTheme.textTheme.headline3),
                          const Padding(
                            padding: EdgeInsets.only(top: 7),
                          ),
                          TextFormField(
                              minLines: 8,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: CustomColor.white,
                                  contentPadding: EdgeInsets.all(15),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: CustomColor.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: CustomColor.black),
                                  ),
                                  hintStyle: TextStyle(
                                      color: CustomColor.secondary,
                                      fontSize: 14)))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // FilePickerResult? result = await FilePicker.platform.pickFiles();
                        final result = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        if (result != null) {
                          setState(() {
                            _image = result.path;
                          });
                        }
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: _image == null
                            ? Image.asset("./image/img.png")
                            : Image.network(_image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(children: [
                        ElevatedButton(
                          child: Text('Create'),
                          onPressed: () async {
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => const AddProduct()),);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 14),
                        ),
                        ElevatedButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
