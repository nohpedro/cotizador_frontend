import '../model/RequestHandler.dart';
import 'LogService.dart';
class TableUsersService {
  final RequestHandler request = RequestHandler();

  Future<List<Map<String, dynamic>>?> fetchAllUsers(String accessToken) async {
    try {
      // Al registrar un evento
      LogService().logEvent('Usuario inició sesión con éxito');
      final response = await request.getRequest(
        'users/', // Endpoint para obtener todos los usuarios
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        print('La respuesta no es válida.');
        return null;
      }
    } catch (e) {
      print('Error en fetchAllUsers: $e');
      return null;
    }
  }
}
