import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/PermissionService.dart';

class PermissionController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> rolesWithoutPermissions = [];
  List<Map<String, dynamic>> rolesWithPermissions = [];
  List<Map<String, dynamic>> allPermissions = [];

  PermissionController({required this.authHandler});

  /// Cargar roles con permisos
  Future<bool> fetchRolesWithPermissions() async {
    try {
      final roles = await PermissionService.fetchRolesWithPermissions(authHandler);
      if (roles != null) {
        rolesWithPermissions = roles;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener roles con permisos: $e');
    }
    return false;
  }


  /// Asignar un permiso a un rol
  Future<bool> assignPermission(int roleId, int permissionId) async {
    final success = await PermissionService.assignPermissionToRole(authHandler, roleId, permissionId);
    if (success) {
      await fetchRolesWithPermissions(); // Refrescar roles con permisos
    }
    return success;
  }

  /// Eliminar un permiso de un rol
  Future<bool> removePermission(int roleId, int permissionId) async {
    final success = await PermissionService.removePermissionFromRole(authHandler, roleId, permissionId);
    if (success) {
      await fetchRolesWithPermissions(); // Refrescar roles con permisos
    }
    return success;
  }

  Future<bool> fetchAllPermissions() async {
    try {
      final permissions = await PermissionService.fetchAllPermissions(authHandler);
      if (permissions != null) {
        allPermissions = permissions;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener permisos predefinidos: $e');
    }
    return false;
  }


  Future<bool> fetchRolesWithoutPermissions() async {
    try {
      final roles = await PermissionService.fetchRolesWithoutPermissions(authHandler);
      if (roles != null) {
        rolesWithoutPermissions = roles;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener roles sin permisos: $e');
    }
    return false;
  }


}
