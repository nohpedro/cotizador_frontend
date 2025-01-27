import 'dart:convert';
import 'package:http/http.dart' as http;

class PiezaService {
  final String baseUrl;

  PiezaService({required this.baseUrl});

  Future<Map<String, dynamic>?> calcularPiezas({
    required int espesor,
    required int largoPieza,
    required int anchoPieza,
    required int cantidadGolpes,
    required int cantidadPiezas,
  }) async {
    final url = Uri.parse('$baseUrl/cotizador/calcular-piezas/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Agrega el token si es necesario
          // 'Authorization': 'Bearer <tu_token>',
        },
        body: jsonEncode({
          "espesor": espesor,
          "largo_pieza": largoPieza,
          "ancho_pieza": anchoPieza,
          "cantidad_golpes": cantidadGolpes,
          "cantidad_piezas": cantidadPiezas,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error realizando la solicitud: $e');
      return null;
    }
  }
}
