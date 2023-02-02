import 'dart:typed_data';
import 'package:client/data/models/publisher.dart';
import 'package:client/data/repositories/publishers_repository.dart';
import 'package:client/presentation/widgets/add_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme.dart';
import '../dashboard/component/appBarActionItems.dart';

class PublisherForm extends StatefulWidget {
  const PublisherForm({Key? key, required this.repository, this.publisher}) : super(key: key);
  final PublisherRepository repository;
  final Publisher? publisher;
  @override
  State<PublisherForm> createState() => _PublisherFormState();
}

class _PublisherFormState extends State<PublisherForm> {

  PublisherRepository get repository => widget.repository;
  Publisher? get publisher => widget.publisher;

  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(publisher != null){
      _nameController.text = publisher!.name!;
      _descriptionController.text = publisher!.description!;
    }
  }
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
              Text('Add Publisher',
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
                            ? (publisher != null && publisher?.image != "") ? Image(image: NetworkImage('${publisher!.image}')) : Image.asset("assets/image/img.png")
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
                              child: publisher != null ? Text('Update') : Text('Create') ,
                              onPressed: () async {
                                if(publisher != null){
                                  await repository.updatePublisher( publisher: publisher!,name: _nameController.text, image: _image, description: _descriptionController.text,);
                                } else {
                                  await repository.createPublisher(name: _nameController.text, image: _image, description: _descriptionController.text);
                                }
                                Navigator.pop(context);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }
}
