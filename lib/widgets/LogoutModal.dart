import 'package:flutter/material.dart';
import '../model/AuthHandler.dart'; // Ajusta la ruta según la ubicación de tu archivo AuthHandler
import '../views/home_page.dart'; // Ajusta la ruta según la ubicación de tu archivo home_page

class LogoutModal {
  static void showLogoutDialog(BuildContext context, AuthHandler authHandler) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Llamar al método de logout
                await authHandler.logout();
                print('Logout exitoso.');
                // Navegar a la pantalla de inicio
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage(imageUrl: 'assets/images/metalize.png',)),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }
}
