import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/text_input_field.dart';
import '../../controllers/UserController.dart';

class EditUserModal extends StatelessWidget {
  final UserController userController;
  final Map<String, dynamic> user;

  const EditUserModal({
    Key? key,
    required this.userController,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController =
    TextEditingController(text: user['nombre']);
    final TextEditingController apellidoController =
    TextEditingController(text: user['apellido']);
    final TextEditingController passwordController =
    TextEditingController(text: '');

    return AlertDialog(
      title: const Text('Editar Usuario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const SizedBox(height: 8),
          TextInputField(hintText: 'Nommbre',controller: nombreController,),
          const SizedBox(height: 8),
          TextInputField(hintText: 'Apellido',controller: apellidoController,),
          const SizedBox(height: 8),
          TextInputField(hintText: 'Nueva Contraseña',controller: passwordController,isPassword: true,),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final id = user['id'];
            final nombre = nombreController.text;
            final apellido = apellidoController.text;
            final password = passwordController.text;

            final success = await userController.PutUser(id, {
              'nombre': nombre,

              'apellido': apellido,
              'password': password,
            });

            Navigator.pop(context, success);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
