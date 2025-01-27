import '../model/RequestHandler.dart';
import '../model/AuthHandler.dart';

class PlanchaService {
  double espesor;
  int largo;
  int ancho;
  double precioValor;
  int proveedorId;
  final AuthHandler authHandler;

  PlanchaService({
    required this.espesor,
    required this.largo,
    required this.ancho,
    required this.precioValor,
    required this.proveedorId,
    required this.authHandler,
  });

  Future<String> CreacionPlancha() async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/planchas/',
        data: {
          "espesor": espesor,
          "largo": largo,
          "ancho": ancho,
          "precio_valor": precioValor,
          "proveedor_id": proveedorId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>?> GetPlanchas(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/planchas/',
        headers: authHandler.getAuthHeaders(),
      );

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        print('La respuesta no es una lista válida.');
        return null;
      }
    } catch (e) {
      print('Error en GetPlanchas: $e');
      return null;
    }
  }

  static Future<bool> eliminarId(AuthHandler authHandler, int id) async {
    try {
      await authHandler.requestHandler.deleteRequest(
        'cotizador/planchas/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return true;
    } catch (e) {
      print('Error en eliminarId: $e');
      return false;
    }
  }

  static Future<bool> editarPlancha(
      AuthHandler authHandler,
      int id,
      Map<String, dynamic> data,
      ) async {
    try {
      // Crear el cuerpo de la petición con los datos esperados por el endpoint
      final Map<String, dynamic> body = {
        'espesor': data['espesor'] ?? 0, // Valor predeterminado si está ausente
        'largo': data['largo'] ?? 0,
        'ancho': data['ancho'] ?? 0,
        'proveedor_id': data['proveedor_id'] ?? 0,
        'precio_valor': data['precio_valor'] ?? 0,
      };


      final response = await authHandler.requestHandler.patchRequest(
        'cotizador/planchas/$id/',
        data: body, // Cuerpo de la petición
        headers: authHandler.getAuthHeaders(),
      );
      return response != null; // Verificar si la respuesta no es nula
    } catch (e) {
      print('Error en editarPlancha: $e');
      return false;
    }
  }

}
