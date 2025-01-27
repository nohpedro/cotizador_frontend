import '../model/AuthHandler.dart';

class UserRoleService {
  /// Obtener usuarios con roles
  static Future<List<Map<String, dynamic>>?> fetchUsersWithRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/usuarios-con-roles/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener usuarios con roles: $e');
    }
    return null;
  }

  /// Obtener usuarios sin roles
  static Future<List<Map<String, dynamic>>?> fetchUsersWithoutRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/usuarios-sin-roles/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener usuarios sin roles: $e');
    }
    return null;
  }

  /// Asignar un rol a un usuario
  static Future<bool> assignRoleToUser(AuthHandler authHandler, int userId, int roleId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/roles/assign/',
        data: {
          'user_id': userId,
          'role_id': roleId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al asignar rol $roleId al usuario $userId: $e');
    }
    return false;
  }

  /// Eliminar un rol de un usuario
  static Future<bool> removeRoleFromUser(AuthHandler authHandler, int userId, int roleId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/roles/remove/',
        data: {
          'user_id': userId,
          'role_id': roleId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al eliminar rol $roleId del usuario $userId: $e');
    }
    return false;
  }


  static Future<List<Map<String, dynamic>>?> fetchRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener los roles: $e');
    }
    return null;
  }


}
