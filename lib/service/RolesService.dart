import '../model/AuthHandler.dart';

class RolesService {
  /// Obtener la lista de roles (GET roles_permisos/roles/)
  static Future<List<Map<String, dynamic>>?> fetchRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener la lista de roles: $e');
    }
    return null;
  }

  /// Obtener un rol por ID (GET roles_permisos/roles/{id}/)
  static Future<Map<String, dynamic>?> fetchRoleById(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al obtener el rol con ID $id: $e');
    }
    return null;
  }

  /// Crear un rol (POST roles_permisos/roles/)
  static Future<bool> createRole(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'roles_permisos/roles/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al crear el rol: $e');
    }
    return false;
  }

  /// Actualizar un rol completo (PUT roles_permisos/roles/{id}/)
  static Future<bool> updateRole(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'roles_permisos/roles/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar el rol con ID $id: $e');
    }
    return false;
  }

  /// Actualizar un rol parcialmente (PATCH roles_permisos/roles/{id}/)
  static Future<bool> patchRole(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'roles_permisos/roles/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar parcialmente el rol con ID $id: $e');
    }
    return false;
  }

  /// Eliminar un rol (DELETE roles_permisos/roles/{id}/)
  static Future<bool> deleteRole(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.deleteRequest(
        'roles_permisos/roles/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al eliminar el rol con ID $id: $e');
    }
    return false;
  }
}
