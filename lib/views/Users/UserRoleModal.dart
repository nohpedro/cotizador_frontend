import 'package:flutter/material.dart';

class UserRoleModal extends StatelessWidget {
  final String title;
  final List<dynamic> roles;
  final Function(int) onSelected;

  const UserRoleModal({
    Key? key,
    required this.title,
    required this.roles,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: roles.isEmpty
            ? const Center(child: Text('No hay roles disponibles.'))
            : ListView.builder(
          shrinkWrap: true,
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];
            return ListTile(
              title: Text(role['name']),
              subtitle: Text(role['description'] ?? 'Sin descripción'),
              onTap: () {
                onSelected(role['id']);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
