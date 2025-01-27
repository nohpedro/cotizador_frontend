import 'package:flutter/material.dart';
import '../../model/AuthHandler.dart';
import '../../service/UserService.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomSnackBar.dart';
import '../../widgets/PasswordVerificationField.dart';
import '../../widgets/text_input_field.dart';


class UserCreationScreen extends StatefulWidget {
  final AuthHandler authHandler;

  const UserCreationScreen({Key? key, required this.authHandler}) : super(key: key);

  @override
  _UserCreationScreenState createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? successMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(context),
            ),
          );
        },
      ),
      bottomSheet: successMessage != null
          ? Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          successMessage!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : null,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CREACIÓN DE USUARIO",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        TextInputField(hintText: 'Nombre',controller: nameController,),
        const SizedBox(height: 16),
        TextInputField(hintText: 'Apellido',controller: lastNameController,),
        const SizedBox(height: 16),
    PasswordVerificationField(
    passwordController: passwordController,
    confirmPasswordController: confirmPasswordController,
    ),
        const SizedBox(height: 24),
        Row(
          children: [
            CustomButton(
              buttonText: "CANCELAR",
              buttonColor: const Color(0xFFB35A58),
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  successMessage = null;
                });
              },
            ),
            const SizedBox(width: 16),
            CustomButton(
              buttonText: "CONFIRMAR",
              buttonColor: const Color(0xFF2E8B57),
              textColor: Colors.white,
              onPressed: () => _createUser(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _createUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      CustomSnackbar.show(
        context,
        message: '¡Complete todos los campos!',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      CustomSnackbar.show(
        context,
        message: 'Las contraseñas no coinciden',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    try {
      final response = await UserService.createUser(widget.authHandler, {
        'nombre': nameController.text,
        'apellido': lastNameController.text,
        'password': passwordController.text,
      });

      if (response != null) {
        setState(() {
          successMessage = '''
Usuario creado exitosamente con las credenciales de:
USERNAME: ${response['username']}
NOMBRE: ${response['nombre']}
APELLIDO: ${response['apellido']}
          ''';
        });
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Ocurrió un error inesperado: $e',
        fontSize: 18.0,
        icon: Icons.error,
      );
    }
  }
}