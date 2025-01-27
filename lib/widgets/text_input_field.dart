import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String hintText;
  final double? width;
  final double height;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const TextInputField({
    Key? key,
    required this.hintText,
    this.width = 550.0,
    this.height = 50.0,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Ajuste para pantallas oscuras
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[600]!, width: 1.0),
      ),
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword && _isObscured,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          // Ícono para campos de contraseña
          if (widget.isPassword)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
              child: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[400],
              ),
            ),
        ],
      ),
    );
  }
}
