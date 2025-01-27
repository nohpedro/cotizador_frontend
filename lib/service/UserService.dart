import '../model/AuthHandler.dart';

class UserService {
  /// Obtener la lista de usuarios (GET /users/users/)
  static Future<List<Map<String, dynamic>>?> fetchUsers(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener la lista de usuarios: $e');
    }
    return null;
  }

  /// Obtener un usuario por ID (GET /users/users/{id})
  static Future<Map<String, dynamic>?> fetchUserById(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al obtener el usuario con ID $id: $e');
    }
    return null;
  }

  /// Crear un usuario (POST /users/users/)
  static Future<Map<String, dynamic>?> createUser(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/users/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al crear el usuario: $e');
    }
    return null;
  }

  /// Actualizar un usuario completamente (PUT /users/users/{id})
  static Future<bool> updateUser(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'users/users/$id/',
        
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar el usuario con ID $id: $e');
    }
    return false;
  }

  /// Actualizar un usuario parcialmente (PATCH /users/users/{id})
  static Future<bool> patchUser(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'users/users/$id',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar parcialmente el usuario con ID $id: $e');
    }
    return false;
  }

  /// Eliminar un usuario (DELETE /users/users/{id})
  static Future<bool> deleteUser(AuthHandler authHandler, int id, int currentUserId) async {
    try {
      if (id == currentUserId) {
        print('Un usuario no puede eliminarse a sí mismo.');
        return false;
      }
      final response = await authHandler.requestHandler.deleteRequest(
        'users/users/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al eliminar el usuario con ID $id: $e');
    }
    return false;
  }

  /// Obtener datos del usuario en sesión (GET /users/users/me/)
  static Future<Map<String, dynamic>?> fetchCurrentUser(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/me/',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al obtener el usuario en sesión: $e');
    }
    return null;
  }
}
