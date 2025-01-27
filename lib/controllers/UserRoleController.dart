import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/UserRoleService.dart';

class UserRoleController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> usersWithRoles = [];
  List<Map<String, dynamic>> usersWithoutRoles = [];
  List<Map<String, dynamic>> roles = [];

  UserRoleController({required this.authHandler});

  /// Obtener usuarios con roles
  Future<bool> fetchUsersWithRoles() async {
    try {
      final users = await UserRoleService.fetchUsersWithRoles(authHandler);
      if (users != null) {
        usersWithRoles = users;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener usuarios con roles: $e');
    }
    return false;
  }

  /// Obtener usuarios sin roles
  Future<bool> fetchUsersWithoutRoles() async {
    try {
      final users = await UserRoleService.fetchUsersWithoutRoles(authHandler);
      if (users != null) {
        usersWithoutRoles = users;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener usuarios sin roles: $e');
    }
    return false;
  }

  /// Asignar un rol a un usuario
  Future<bool> assignRoleToUser(int userId, int roleId) async {
    final success = await UserRoleService.assignRoleToUser(authHandler, userId, roleId);
    if (success) {
      await fetchUsersWithRoles(); // Refrescar usuarios con roles
      await fetchUsersWithoutRoles(); // Refrescar usuarios sin roles
    }
    return success;
  }

  /// Eliminar un rol de un usuario
  Future<bool> removeRoleFromUser(int userId, int roleId) async {
    final success = await UserRoleService.removeRoleFromUser(authHandler, userId, roleId);
    if (success) {
      await fetchUsersWithRoles(); // Refrescar usuarios con roles
    }
    return success;
  }

  Future<bool> fetchRoles() async {
    try {
      final fetchedRoles = await UserRoleService.fetchRoles(authHandler);
      if (fetchedRoles != null) {
        roles = fetchedRoles;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener los roles: $e');
    }
    return false;
  }

}
