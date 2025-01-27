import 'package:flutter/material.dart';
import '../../widgets/Buscador_widget.dart';
import '../../widgets/tabla_generica_widget.dart';
import '../../controllers/proveedor_controller.dart';

class ProveedorScreen extends StatefulWidget {
  final ProveedorController proveedorController;

  const ProveedorScreen({Key? key, required this.proveedorController}) : super(key: key);

  @override
  _ProveedorScreenState createState() => _ProveedorScreenState();
}

class _ProveedorScreenState extends State<ProveedorScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> proveedoresOriginales = [];
  List<Map<String, dynamic>> proveedoresFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  /// Carga la lista de proveedores desde el controlador
  Future<void> _cargarProveedores() async {
    try {
      await widget.proveedorController.fetchProveedores();
      setState(() {
        proveedoresOriginales = widget.proveedorController.proveedores.map((proveedor) {
          return {
            'id': proveedor['id'],
            'nombre': proveedor['nombre'],
          };
        }).toList();
        proveedoresFiltrados = List.from(proveedoresOriginales);
      });
    } catch (e) {
      print('Error al cargar los proveedores: $e');
    }
  }

  /// Filtra la lista de proveedores según [texto] y [filtro].
  void _filtrarProveedores(String texto, String filtro) {
    setState(() {
      proveedoresFiltrados = proveedoresOriginales.where((proveedor) {
        final valor = proveedor[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  /// Elimina los proveedores dados por [ids].
  Future<void> _eliminarProveedores(List<int> ids) async {
    for (var id in ids) {
      await widget.proveedorController.eliminarProveedor(id);
    }
    await _cargarProveedores();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Proveedores'),
          automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          // Buscador
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'nombre'],
            onBuscar: _filtrarProveedores,
          ),
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'NOMBRE'],
              obtenerDatos: () async {
                return proveedoresFiltrados;
              },
              onEliminar: _eliminarProveedores,
              onEditar: (proveedor) async {
                final TextEditingController nombreController = TextEditingController(
                  text: proveedor['nombre'],
                );

                final resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Editar Proveedor'),
                    content: TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(hintText: 'Nombre del proveedor'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final id = proveedor['id'];
                          final nuevoNombre = nombreController.text;
                          final success = await widget.proveedorController.editarProveedor(id, nuevoNombre);
                          Navigator.pop(context, success);
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );

                if (resultado == true) {
                  await _cargarProveedores();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
