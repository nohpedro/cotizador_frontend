import '../model/AuthHandler.dart';

class CotizacionService {
  /// Calcular piezas
  static Future<Map<String, dynamic>?> calcularPiezas(
      AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/calcular-piezas/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al calcular piezas: $e');
      return null;
    }
  }

  /// Registrar venta
  static Future<Map<String, dynamic>?> registrarVenta(
      AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'clientes_ventas_cotizaciones/ventas/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al registrar la venta: $e');
      return null;
    }
  }

  /// Crear cotización
  static Future<Map<String, dynamic>?> crearCotizacion(
      AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'clientes_ventas_cotizaciones/cotizaciones/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al crear cotización: $e');
      return null;
    }
  }
}
