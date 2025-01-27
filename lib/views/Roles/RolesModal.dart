import 'package:flutter/material.dart';
import '../../controllers/RolesController.dart';

class RolesModal extends StatelessWidget {
  final RolesController rolesController;
  final Map<String, dynamic> rol;

  const RolesModal({Key? key, required this.rolesController, required this.rol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: rol['name']);
    final TextEditingController descriptionController = TextEditingController(text: rol['description']);

    return AlertDialog(
      title: const Text('Editar Rol'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Nombre del Rol'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Descripción del Rol'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final id = rol['id'];
            final name = nameController.text.trim();
            final description = descriptionController.text.trim();

            final success = await rolesController.updateRole(id, name, description);
            Navigator.pop(context, success);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
