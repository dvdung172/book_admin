
import 'package:client/data/repositories/customers_repository.dart';
import 'package:client/presentation/views/customers/customers_form.dart';
import 'package:client/presentation/views/customers/customers_table.dart';
import 'package:flutter/material.dart';

import '../../../core/responsive.dart';
import '../../../core/theme.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final CustomerRepository _customerRepository = CustomerRepository();
  String textSearch = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer',
                      style: CustomTheme.mainTheme.textTheme.headline1),
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? 500
                            : double.infinity,
                        height: 36,
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            hintText: 'Search...',
                          ),
                          onChanged: (text) {
                            setState(() {
                              textSearch = text;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Add'),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  CustomersForm(repository: _customerRepository,)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
            ),
            Center(
                child: CustomersTable(
              repository: _customerRepository, textSearch: textSearch,
            )),
          ],
        ),
      ),
    );
  }
}
