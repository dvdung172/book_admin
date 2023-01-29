import 'dart:io';
import 'dart:typed_data';

import 'package:client/core/responsive.dart';
import 'package:client/data/models/category.dart';
import 'package:client/data/repositories/categories_repository.dart';
import 'package:client/presentation/widgets/add_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/di.dart';
import '../dashboard/component/appBarActionItems.dart';
import '../sideMenu.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key? key, required this.repository, this.category}) : super(key: key);
  final CategoryRepository repository;
  final Category? category;
  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {

  CategoryRepository get repository => widget.repository;
  Category? get category => widget.category;

  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    if(category != null){
      _nameController.text = category!.name!;
      _descriptionController.text = category!.description!;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: CustomColor.black)),
        actions:  [
          AppBarActionItems(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Category',
                  style: CustomTheme.mainTheme.textTheme.headline1),
              const Padding(
                padding: EdgeInsets.only(top: 21),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AddTextField(
                      title: 'Name',
                      controller: _nameController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                            withData: true
                        );
                        if (result != null) {
                          Uint8List fileBytes = result.files.first.bytes!;
                          setState(() {
                            _image = fileBytes;
                          });
                        }
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child:  _image == null
                            ? (category != null && category?.image != "") ? Image(image: NetworkImage('${category!.image}')) : Image.asset("assets/image/img.png")
                            : Image.memory(_image),
                      ),
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
                              controller: _descriptionController,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 21),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: category != null ? Text('Update') : Text('Create') ,
                              onPressed: () async {
                                if(category != null){
                                  repository.updateCategory( category: category!,name: _nameController.text, image: _image, description: _descriptionController.text,);
                                } else {
                                  repository.createCategory(name: _nameController.text, image: _image, description: _descriptionController.text);
                                }
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
