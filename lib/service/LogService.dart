import 'dart:convert';

class LogService {
  static LogService? _instance;
  final List<String> _logs = []; // Almacenamiento en memoria para los logs

  LogService._internal();

  factory LogService() {
    _instance ??= LogService._internal();
    return _instance!;
  }

  // Agregar un evento al log
  void logEvent(String event) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $event';
    _logs.add(logEntry);
    print(logEntry); // Para depuración en consola
  }

  // Obtener todos los logs como texto
  String getLogs() {
    return _logs.join('\n');
  }

  // Limpiar los logs
  void clearLogs() {
    _logs.clear();
  }

  // Exportar logs como archivo (para descargar en Web)
  Future<String> exportLogs() async {
    final logsContent = _logs.join('\n');
    // Puedes implementar lógica para guardar/exportar en web
    return base64Encode(utf8.encode(logsContent));
  }
  
}
