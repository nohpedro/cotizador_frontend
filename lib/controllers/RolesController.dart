import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/RolesService.dart';

class RolesController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> roles = [];
  Map<String, dynamic>? selectedRole;

  RolesController({required this.authHandler});

  /// Obtener todos los roles
  Future<bool> fetchRoles() async {
    try {
      final resultado = await RolesService.fetchRoles(authHandler);
      if (resultado != null) {
        roles = resultado;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener roles: $e');
    }
    return false;
  }

  /// Obtener un rol por ID
  Future<bool> fetchRoleById(int id) async {
    try {
      final resultado = await RolesService.fetchRoleById(authHandler, id);
      if (resultado != null) {
        selectedRole = resultado;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener el rol con ID $id: $e');
    }
    return false;
  }

  /// Crear un rol
  Future<bool> createRole(String name, String description) async {
    try {
      final success = await RolesService.createRole(authHandler, {
        'name': name,
        'description': description,
      });
      if (success) {
        await fetchRoles(); // Refrescar la lista de roles después de crear
        return true;
      }
    } catch (e) {
      print('Error al crear rol: $e');
    }
    return false;
  }

  /// Actualizar un rol (completo)
  Future<bool> updateRole(int id, String name, String description) async {
    try {
      final success = await RolesService.updateRole(authHandler, id, {
        'name': name,
        'description': description,
      });
      if (success) {
        await fetchRoles(); // Refrescar la lista de roles después de actualizar
        return true;
      }
    } catch (e) {
      print('Error al actualizar rol con ID $id: $e');
    }
    return false;
  }

  /// Actualizar parcialmente un rol
  Future<bool> patchRole(int id, Map<String, dynamic> data) async {
    try {
      final success = await RolesService.patchRole(authHandler, id, data);
      if (success) {
        await fetchRoles(); // Refrescar la lista de roles después de actualizar
        return true;
      }
    } catch (e) {
      print('Error al actualizar parcialmente el rol con ID $id: $e');
    }
    return false;
  }

  /// Eliminar un rol
  Future<bool> deleteRole(int id) async {
    try {
      final success = await RolesService.deleteRole(authHandler, id);
      if (success) {
        await fetchRoles(); // Refrescar la lista de roles después de eliminar
        return true;
      }
    } catch (e) {
      print('Error al eliminar rol con ID $id: $e');
    }
    return false;
  }
}
