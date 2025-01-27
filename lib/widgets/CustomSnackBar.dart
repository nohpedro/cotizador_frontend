import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        Color textColor = Colors.white,
        bool isBold = false,
        double fontSize = 14.0,
        IconData icon = Icons.info_outline,
      }) {
    final overlay = Overlay.of(context); // Obtiene el Overlay para superponer
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50, // Posición más baja en la pantalla
        left: MediaQuery.of(context).size.width * 0.2,
        right: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2F33), // Fondo estilo Discord
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF7289DA), // Color de ícono
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(entry);
    Future.delayed(const Duration(seconds: 4), () {
      entry.remove();
    });
  }
}
