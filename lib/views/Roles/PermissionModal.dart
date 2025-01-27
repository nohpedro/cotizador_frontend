import 'package:flutter/material.dart';

class PermissionModal extends StatelessWidget {
  final String title;
  final List<dynamic> permissions;
  final Function(int) onSelected;

  const PermissionModal({
    Key? key,
    required this.title,
    required this.permissions,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: permissions.length,
          itemBuilder: (context, index) {
            final permission = permissions[index];
            return ListTile(
              title: Text(permission['name']),
              onTap: () {
                onSelected(permission['id']);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
