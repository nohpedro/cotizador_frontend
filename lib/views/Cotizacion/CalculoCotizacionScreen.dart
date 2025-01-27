import 'package:flutter/material.dart';
import '../../controllers/CalculoController.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/ResultadoWidget.dart';
import '../../widgets/text_input_field.dart';

class CalculoPiezasScreen extends StatefulWidget {
  final CalculoController calculoController;

  const CalculoPiezasScreen({Key? key, required this.calculoController}) : super(key: key);

  @override
  _CalculoPiezasScreenState createState() => _CalculoPiezasScreenState();
}

class _CalculoPiezasScreenState extends State<CalculoPiezasScreen> {
  final TextEditingController espesorController = TextEditingController();
  final TextEditingController largoController = TextEditingController();
  final TextEditingController anchoController = TextEditingController();
  final TextEditingController golpesController = TextEditingController();
  final TextEditingController piezasController = TextEditingController();

  Map<String, dynamic>? resultado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Piezas'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ingrese los datos de la pieza para el cálculo:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputFields(),
            const SizedBox(height: 16),
            CustomButton(
              buttonText: 'Calcular',
              buttonColor: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                if (!_validarCampos()) {
                  _mostrarError('Por favor, complete todos los campos.');
                  return;
                }

                final datos = {
                  "espesor": double.tryParse(espesorController.text) ?? 0,
                  "largo_pieza": double.tryParse(largoController.text) ?? 0,
                  "ancho_pieza": double.tryParse(anchoController.text) ?? 0,
                  "cantidad_golpes": int.tryParse(golpesController.text) ?? 0,
                  "cantidad_piezas": int.tryParse(piezasController.text) ?? 0,
                };

                final success = await widget.calculoController.calcularPiezas(datos);
                if (success) {
                  setState(() {
                    resultado = widget.calculoController.getResultado();
                  });
                } else {
                  _mostrarError('Error al calcular las piezas. Inténtelo nuevamente.');
                }
              },
            ),
            const SizedBox(height: 24),
            if (resultado != null) ResultadoWidget(resultado: resultado!),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextInputField(
          hintText: 'Espesor (mm)',
          controller: espesorController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: 'Largo de la pieza (mm)',
          controller: largoController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: 'Ancho de la pieza (mm)',
          controller: anchoController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: 'Cantidad de golpes',
          controller: golpesController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: 'Cantidad de piezas',
          controller: piezasController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  bool _validarCampos() {
    return espesorController.text.isNotEmpty &&
        largoController.text.isNotEmpty &&
        anchoController.text.isNotEmpty &&
        golpesController.text.isNotEmpty &&
        piezasController.text.isNotEmpty;
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }
}
