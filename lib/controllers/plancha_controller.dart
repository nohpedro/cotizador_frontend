import 'package:flutter/material.dart';
import '../service/PlanchasService.dart';
import '../model/AuthHandler.dart';

class PlanchaController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> planchas = [];
  bool isLoading = false;

  PlanchaController({required this.authHandler});

  Future<void> fetchPlanchas() async {
    isLoading = true;

    Future.delayed(Duration.zero, () => notifyListeners()); // Notificar después de completar la construcción

    try {
      final result = await PlanchaService.GetPlanchas(authHandler);
      if (result != null) {
        planchas = result.map((plancha) {
          return {
            'id': int.tryParse(plancha['id'].toString()) ?? 0,
            'espesor': plancha['espesor'],
            'largo': plancha['largo'],
            'ancho': plancha['ancho'],
            'precio': plancha['precio'],
            'proveedor': {
              'id': int.tryParse(plancha['proveedor']['id'].toString()) ?? 0,
              'nombre': plancha['proveedor']['nombre'],
            },
          };
        }).toList();
      }
    } catch (e) {
      print('Error al obtener las planchas: $e');
    }

    isLoading = false;

    Future.delayed(Duration.zero, () => notifyListeners()); // Notificar después
  }


  Future<void> eliminarPlancha(int id) async {
    try {
      final success = await PlanchaService.eliminarId(authHandler, id);
      if (success) {
        planchas.removeWhere((plancha) => plancha['id'] == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error al eliminar la plancha: $e');
    }
  }

  Future<bool> editarPlancha(int id, Map<String, dynamic> nuevosDatos) async {
    try {
      // Validar y preparar el formato de datos para el servicio
      final Map<String, dynamic> datosFormateados = {
        'espesor': nuevosDatos['espesor'] ?? 0,
        'largo': nuevosDatos['largo'] ?? 0,
        'ancho': nuevosDatos['ancho'] ?? 0,
        'proveedor_id': nuevosDatos['proveedor_id'] ?? 0,
        'precio_valor': nuevosDatos['precio_valor'] ?? 0,
      };

      // Enviar al servicio para editar
      final success = await PlanchaService.editarPlancha(authHandler, id, datosFormateados);
      if (success) {
        // Actualizar lista local si el servicio es exitoso
        final index = planchas.indexWhere((plancha) => plancha['id'] == id);
        if (index != -1) {
          planchas[index] = {...planchas[index], ...datosFormateados};
        }
        notifyListeners(); // Notificar cambios a los oyentes
      }
      return success;
    } catch (e) {
      print('Error al editar la plancha: $e');
      return false;
    }
  }

}
