import 'package:flutter/material.dart';

class PasswordVerificationField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final double width;
  final double height;

  const PasswordVerificationField({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
    this.width = 550.0,
    this.height = 50.0,
  }) : super(key: key);

  @override
  _PasswordVerificationFieldState createState() =>
      _PasswordVerificationFieldState();
}

class _PasswordVerificationFieldState extends State<PasswordVerificationField> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  double _strengthLevel = 0.0;
  String _strengthLabel = "";
  Color _strengthColor = Colors.red;

  /// Validar la fortaleza de la contraseña
  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _strengthLevel = 0.0;
        _strengthLabel = "Ingresa una contraseña";
        _strengthColor = Colors.red;
        return;
      }

      int strength = 0;
      bool hasLength = password.length >= 12;
      bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
      bool hasNumbers = password.contains(RegExp(r'\d'));
      bool hasSpecialChars = password.contains(RegExp(r'[!@#\$&*~]'));
      bool hasCommonPatterns = password.contains(RegExp(r'(password|1234|admin|qwerty)', caseSensitive: false));

      if (hasLength) strength++;
      if (hasUpperCase) strength++;
      if (hasLowerCase) strength++;
      if (hasNumbers) strength++;
      if (hasSpecialChars) strength++;

      if (hasCommonPatterns) {
        _strengthLevel = 0.5;
        _strengthLabel = "Evita palabras comunes";
        _strengthColor = Colors.orange;
        return;
      }

      switch (strength) {
        case 5:
          _strengthLevel = 1.0;
          _strengthLabel = "Fortaleza: Muy fuerte";
          _strengthColor = Colors.green;
          break;
        case 4:
          _strengthLevel = 0.8;
          _strengthLabel = "Fortaleza: Fuerte";
          _strengthColor = Colors.lightGreen;
          break;
        case 3:
          _strengthLevel = 0.6;
          _strengthLabel = "Fortaleza: Moderada";
          _strengthColor = Colors.yellow;
          break;
        case 2:
          _strengthLevel = 0.4;
          _strengthLabel = "Fortaleza: Débil";
          _strengthColor = Colors.orange;
          break;
        default:
          _strengthLevel = 0.2;
          _strengthLabel = "Muy débil";
          _strengthColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contraseña",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: widget.passwordController,
          hintText: "Ingresa la contraseña",
          isPasswordVisible: _isPasswordVisible,
          onVisibilityToggle: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          onChanged: _validatePassword,
        ),
        const SizedBox(height: 8),
        Container(
          width: widget.width,
          height: 5.0, // Altura fija para la barra de fortaleza
          child: LinearProgressIndicator(
            value: _strengthLevel,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(_strengthColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _strengthLabel,
          style: TextStyle(color: _strengthColor),
        ),
        const SizedBox(height: 16),
        const Text(
          "Confirmar Contraseña",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: widget.confirmPasswordController,
          hintText: "Confirma la contraseña",
          isPasswordVisible: _isConfirmPasswordVisible,
          onVisibilityToggle: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            if (widget.passwordController.text !=
                widget.confirmPasswordController.text) {
              return const Text(
                "Las contraseñas no coinciden",
                style: TextStyle(color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
    Function(String)? onChanged,
  }) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[600]!, width: 1.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !isPasswordVisible,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: onVisibilityToggle,
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
