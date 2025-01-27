import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/UserService.dart';

class UserController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? selectedUser;
  Map<String, dynamic>? currentUser;

  UserController({required this.authHandler});

  /// Obtener todos los usuarios
  Future<bool> fetchUsers() async {
    try {
      final resultado = await UserService.fetchUsers(authHandler);
      if (resultado != null) {
        users = resultado;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener usuarios: $e');
    }
    return false;
  }

  /// Obtener un usuario por ID
  Future<bool> fetchUserById(int id) async {
    try {
      final resultado = await UserService.fetchUserById(authHandler, id);
      if (resultado != null) {
        selectedUser = resultado;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener el usuario con ID $id: $e');
    }
    return false;
  }

  /// Crear un usuario
  Future<bool> createUser(String nombre, String apellido, String password) async {
    try {
      final response = await UserService.createUser(authHandler, {
        'nombre': nombre,
        'apellido': apellido,
        'password': password,
      });
      if (response != null) {
        await fetchUsers(); // Refrescar la lista de usuarios
        return true;
      }
    } catch (e) {
      print('Error al crear usuario: $e');
    }
    return false;
  }

  /// Actualizar un usuario completamente
  Future<bool> updateUser(int id, String nombre, String apellido, String password) async {
    try {
      final success = await UserService.updateUser(authHandler, id, {
        'nombre': nombre,
        'apellido': apellido,
        'password': password,
      });
      if (success) {
        await fetchUsers(); // Refrescar la lista de usuarios
        return true;
      }
    } catch (e) {
      print('Error al actualizar usuario con ID $id: $e');
    }
    return false;
  }

  /// Actualizar parcialmente un usuario
  Future<bool> PutUser(int id, Map<String, dynamic> data) async {
    try {
      final success = await UserService.updateUser(authHandler, id, data);
      if (success) {
        await fetchUsers(); // Refrescar la lista de usuarios
        return true;
      }
    } catch (e) {
      print('Error al actualizar parcialmente el usuario con ID $id: $e');
    }
    return false;
  }

  /// Eliminar un usuario
  Future<bool> deleteUser(int id) async {
    try {
      final currentUserData = await UserService.fetchCurrentUser(authHandler);
      if (currentUserData != null) {
        currentUser = currentUserData;
        if (id == currentUser!['id']) {
          print('Un usuario no puede eliminarse a sí mismo.');
          return false;
        }
      }
      final success = await UserService.deleteUser(authHandler, id, currentUser!['id']);
      if (success) {
        await fetchUsers(); // Refrescar la lista de usuarios
        return true;
      }
    } catch (e) {
      print('Error al eliminar usuario con ID $id: $e');
    }
    return false;
  }

  /// Obtener datos del usuario en sesión
  Future<void> fetchCurrentUser() async {
    try {
      final data = await UserService.fetchCurrentUser(authHandler);
      if (data != null) {
        currentUser = data;
        notifyListeners();
      }
    } catch (e) {
      print('Error al obtener el usuario en sesión: $e');
    }
  }
}
