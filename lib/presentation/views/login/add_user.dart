import 'dart:typed_data';
import 'package:client/data/models/product.dart';
import 'package:client/data/repositories/authors_repository.dart';
import 'package:client/data/repositories/categories_repository.dart';
import 'package:client/data/repositories/products_repository.dart';
import 'package:client/data/repositories/publishers_repository.dart';
import 'package:client/presentation/widgets/add_dropdown_search.dart';
import 'package:client/presentation/widgets/add_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme.dart';
import 'package:flutter/services.dart';
import '../dashboard/component/appBarActionItems.dart';

class ProductsForm extends StatefulWidget {
  const ProductsForm({Key? key, required this.repository, this.product}) : super(key: key);
  final ProductRepository repository;
  final Product? product;
  @override
  State<ProductsForm> createState() => _ProductsFormState();
}

class _ProductsFormState extends State<ProductsForm> {

  ProductRepository get repository => widget.repository;
  Product? get product => widget.product;

  var _image;
  var _isActive = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(product != null){
      _nameController.text = product!.name!;
      _descriptionController.text = product!.description!;
      _authorController.text = product!.author!;
      _publisherController.text = product!.publisher!;
      _stockController.text = product!.stock!.toString();
      _priceController.text = product!.price!.toString();
      _categoryController.text = product!.category!;
      _isActive = product!.isActived;
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
              Text('Add Product',
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
                            AddTextField(title: 'Price', controller:  _priceController, inputType: TextInputType.number,
                              inputFormater: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],),
                            AddTextField(title: 'Stock',controller:  _stockController,inputType: TextInputType.number,
                              inputFormater: [FilteringTextInputFormatter.digitsOnly],),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                children: [
                                  Text("Active",style: CustomTheme.mainTheme.textTheme.headline3),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 21),
                                  ),
                                  Switch(
                                    value: _isActive,
                                    activeColor: Colors.blue,
                                    onChanged: (bool value) async {
                                      setState(() {
                                        _isActive = !_isActive;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 34),
                        ),
                        Column(
                          children: [
                            AddDropdownSearch(title: 'Author', controller: _authorController, listData: AuthorRepository().getAllauthors(),),
                            AddDropdownSearch(title: 'Publisher', controller: _publisherController, listData: PublisherRepository().getAllPublishers(),),
                            AddDropdownSearch(title: 'Category',controller: _categoryController, listData: CategoryRepository().getAllCategories(),),
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
                            ? (product != null && product?.image != "") ? Image(image: NetworkImage('${product!.image}')) : Image.asset("assets/image/img.png")
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
                              child: product != null ? Text('Update') : Text('Create') ,
                              onPressed: () async {
                                if(product != null){
                                  await repository.updateProduct( product: product!,name: _nameController.text, image: _image, description: _descriptionController.text, author: _authorController.text, category: _categoryController.text, publisher: _publisherController.text, price: int.parse(_priceController.text), stock: int.parse(_stockController.text), isActived: _isActive);
                                } else {
                                  await repository.createProduct(name: _nameController.text, image: _image, description: _descriptionController.text, author: _authorController.text, category: _categoryController.text, publisher: _publisherController.text, price: int.parse(_priceController.text), stock: int.parse(_stockController.text), isActived: _isActive);
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
    _authorController.dispose();
    _priceController.dispose();
    _publisherController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
  }
}
