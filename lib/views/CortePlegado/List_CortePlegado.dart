import 'package:flutter/material.dart';
import '../../widgets/Buscador_widget.dart';
import '../../widgets/tabla_generica_widget.dart';
import '../../controllers/CortePlegado/corte_plegado_controller.dart';

class CortePlegadoScreen extends StatefulWidget {
  final CortePlegadoController cortePlegadoController;

  const CortePlegadoScreen({Key? key, required this.cortePlegadoController}) : super(key: key);

  @override
  _CortePlegadoScreenState createState() => _CortePlegadoScreenState();
}

class _CortePlegadoScreenState extends State<CortePlegadoScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> cortePlegadoOriginales = [];
  List<Map<String, dynamic>> cortePlegadoFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarCortePlegado();
  }

  Future<void> _cargarCortePlegado() async {
    await widget.cortePlegadoController.fetchCortePlegado();
    setState(() {
      cortePlegadoOriginales = widget.cortePlegadoController.cortePlegadoLista.map((corte) {
        return {
          'id': corte['id'],
          'espesor': corte['espesor'],
          'largo': corte['largo'],
          'precio': corte['precio'], // Campo precio incluido
        };
      }).toList();
      cortePlegadoFiltrados = List.from(cortePlegadoOriginales);
    });
  }

  void _filtrarCortePlegado(String texto, String filtro) {
    setState(() {
      cortePlegadoFiltrados = cortePlegadoOriginales.where((corte) {
        final valor = corte[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarCortePlegado(List<int> ids) async {
    for (var id in ids) {
      await widget.cortePlegadoController.eliminarCortePlegado(id);
    }
    await _cargarCortePlegado();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Corte Plegado'),
          automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'espesor', 'largo', 'precio'],
            onBuscar: _filtrarCortePlegado,
          ),
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'ESPESOR', 'LARGO', 'PRECIO'],
              obtenerDatos: () async => cortePlegadoFiltrados,
              onEliminar: _eliminarCortePlegado,
              onEditar: (corte) async {
                final TextEditingController espesorController =
                TextEditingController(text: corte['espesor'].toString());
                final TextEditingController largoController =
                TextEditingController(text: corte['largo'].toString());
                final TextEditingController precioController =
                TextEditingController(text: corte['precio'].toString());

                final resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Editar Corte Plegado'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: espesorController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Espesor'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: largoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Largo'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: precioController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Precio'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final id = corte['id'];
                          final espesor = double.tryParse(espesorController.text) ?? 0;
                          final largo = double.tryParse(largoController.text) ?? 0;
                          final precio = double.tryParse(precioController.text) ?? 0;

                          final success = await widget.cortePlegadoController.editarCortePlegado(
                            id,
                            {
                              'espesor': espesor,
                              'largo': largo,
                              'precio': precio,
                            },
                          );
                          Navigator.pop(context, success);
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );

                if (resultado == true) {
                  await _cargarCortePlegado();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
