import 'dart:typed_data';
import 'package:client/core/responsive.dart';
import 'package:client/data/models/customer.dart';
import 'package:client/data/models/customer.dart';
import 'package:client/data/repositories/authors_repository.dart';
import 'package:client/data/repositories/categories_repository.dart';
import 'package:client/data/repositories/customers_repository.dart';
import 'package:client/data/repositories/customers_repository.dart';
import 'package:client/data/repositories/publishers_repository.dart';
import 'package:client/presentation/widgets/add_dropdown_search.dart';
import 'package:client/presentation/widgets/add_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme.dart';
import 'package:flutter/services.dart';
import '../dashboard/component/appBarActionItems.dart';

class CustomersForm extends StatefulWidget {
  const CustomersForm({Key? key, required this.repository, this.customer}) : super(key: key);
  final CustomerRepository repository;
  final Customer? customer;
  @override
  State<CustomersForm> createState() => _CustomersFormState();
}

class _CustomersFormState extends State<CustomersForm> {

  CustomerRepository get repository => widget.repository;
  Customer? get customer => widget.customer;

  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(customer != null){
      _nameController.text = customer!.name!;
      _emailController.text = customer!.email!;
      _phoneController.text = customer!.phone!;
      _addressController.text = customer!.address!;
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
              Text('Add Customer',
                  style: CustomTheme.mainTheme.textTheme.headline1),
              const Padding(
                padding: EdgeInsets.only(top: 21),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddTextField(title: 'Name', controller: _nameController,),
                            AddTextField(title: 'Phone', controller:  _phoneController, inputType: TextInputType.number,
                              inputFormater: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),LengthLimitingTextInputFormatter(10),],),
                            AddTextField(title: 'Email',controller:  _emailController,inputType: TextInputType.emailAddress,),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 34),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Address",
                                style: CustomTheme.mainTheme.textTheme.headline3),
                            const Padding(
                              padding: EdgeInsets.only(top: 7),
                            ),
                            SizedBox(
                              width: Responsive.isDesktop(context) ? 500 : double.infinity,
                              height: 100,
                              child: TextFormField(
                                  controller: _addressController,
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
                            )
                          ],
                        )

                      ],
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
                            ? (customer != null && customer?.image != "") ? Image(image: NetworkImage('${customer!.image}')) : Image.asset("assets/image/img.png")
                            : Image.memory(_image),
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
                              child: customer != null ? Text('Update') : Text('Create') ,
                              onPressed: () async {
                                if(customer != null){
                                  await repository.updateCustomer(customer: customer!, name: _nameController.text, image: _image, phone: _phoneController.text, email: _emailController.text, address: _addressController.text);
                                } else {
                                  await repository.createCustomer( name: _nameController.text, image: _image, phone: _phoneController.text, email: _emailController.text, address: _addressController.text);
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
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }
}
