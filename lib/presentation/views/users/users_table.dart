import 'package:client/data/models/user.dart';
import 'package:client/data/repositories/users_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/CustomCell.dart';
import 'users_form.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({Key? key, required this.repository, required this.textSearch}) : super(key: key);
  final UserRepository repository;
  final String textSearch;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: repository.getAllUsersWithStream(filter: textSearch),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong...'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else
        {
          List<User> data = snapshot.data!.docs.map((e) => e.data() as User).toList();
          data.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return PaginatedDataTable(
            dataRowHeight: 70,
            source: CategoriesSource(data: data, context: context, repository: repository),
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'STT',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Image',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Description',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'CreatedAt',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Action',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          );
        }

      },
    );
  }
}

class CategoriesSource extends DataTableSource {
  CategoriesSource({required this.context,required this.data,required this.repository});
  final BuildContext context;
  final List<User> data;
  final UserRepository repository;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: <DataCell>[
      DataCell(TextCell('$index')),
      DataCell(Container(
        padding: EdgeInsets.all(5),
        constraints: const BoxConstraints(
            minWidth: 100, maxWidth: 200, minHeight: 150, maxHeight: 300),
        child: (data[index].image != '' && data[index].image != null)
            ? Image(image: NetworkImage('${data[index].image}'))
            : Image.asset("assets/image/img.png"),
      )),
      DataCell(TextCell('${data[index].name}')),
      DataCell(Container(
          constraints: const BoxConstraints(
              minWidth: 150, maxWidth: 300),
          child: Text('${data[index].description}', overflow: TextOverflow.ellipsis,))),
      DataCell(TextCell('${data[index].createdAt}')),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.edit_note_sharp),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  UserForm(repository: repository, user: data[index])));
            },
          ),
          IconButton(
            splashRadius: 17,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (value) =>  CupertinoAlertDialog(
                    title:  Text("Delete Item"),
                    content:  Text("Are you sure you want delete this item?"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text("Yes"),
                        onPressed: () async {
                          await repository.deleteUser(id: data[index].id!);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text("No"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
              );
            },
          ),
        ],
      )),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
