// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteId;

  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateEdit,
      required this.deleteId});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(onSelected: ((value) {
          if (value == 'edit') {
            //edit pg
            navigateEdit(item);
          } else if (value == 'delete') {
            // delete  & refresh
            deleteId(id);
          }
        }), itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text('Edit'),
              value: 'edit',
            ),
            PopupMenuItem(
              child: Text('Delete'),
              value: 'delete',
            ),
          ];
        }),
      ),
    );
  }
}
