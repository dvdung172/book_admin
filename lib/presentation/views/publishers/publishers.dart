
import 'package:client/data/repositories/publishers_repository.dart';
import 'package:client/presentation/views/publishers/publishers_form.dart';
import 'package:client/presentation/views/publishers/publishers_table.dart';
import 'package:flutter/material.dart';

import '../../../core/responsive.dart';
import '../../../core/theme.dart';

class Publishers extends StatefulWidget {
  const Publishers({Key? key}) : super(key: key);

  @override
  State<Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<Publishers> {
  final PublisherRepository _publisherRepository = PublisherRepository();
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
                  Text('Publishers',
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
                                  builder: (context) =>  PublisherForm(repository: _publisherRepository,)));
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
                child: PublishersTable(
              repository: _publisherRepository, textSearch: textSearch,
            )),
          ],
        ),
      ),
    );
  }
}
