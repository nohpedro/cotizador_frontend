import 'package:flutter/material.dart';
import '../../widgets/Buscador_widget.dart';
import '../../widgets/tabla_generica_widget.dart';
import '../../controllers/RolesController.dart';
import 'RolesModal.dart';

class ListRolesScreen extends StatefulWidget {
  final RolesController rolesController;

  const ListRolesScreen({Key? key, required this.rolesController}) : super(key: key);

  @override
  _ListRolesScreenState createState() => _ListRolesScreenState();
}

class _ListRolesScreenState extends State<ListRolesScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> rolesOriginales = [];
  List<Map<String, dynamic>> rolesFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    print('Cargando roles desde el controlador...');
    await widget.rolesController.fetchRoles();
    print('Roles obtenidos: ${widget.rolesController.roles}');
    setState(() {
      rolesOriginales = widget.rolesController.roles.map((rol) {
        return {
          'id': rol['id'],
          'name': rol['name'],
          'description': rol['description'],
        };
      }).toList();
      print('Roles mapeados para la tabla: $rolesOriginales');
      rolesFiltrados = List.from(rolesOriginales);
    });
  }

  void _filtrarRoles(String texto, String filtro) {
    print('Filtrando roles con texto "$texto" y filtro "$filtro"...');
    setState(() {
      rolesFiltrados = rolesOriginales.where((rol) {
        final valor = rol[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
    print('Roles filtrados: $rolesFiltrados');
  }

  Future<void> _eliminarRoles(List<int> ids) async {
    print('Eliminando roles con IDs: $ids...');
    for (var id in ids) {
      await widget.rolesController.deleteRole(id);
    }
    await _cargarRoles();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Listado de Roles'),
        automaticallyImplyLeading: false, // Eliminar la flecha de retroceso
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'name', 'description'],
            onBuscar: _filtrarRoles,
          ),
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'NOMBRE', 'DESCRIPCIÓN'],
              obtenerDatos: () async {
                print('Obteniendo datos para la tabla...');
                return rolesFiltrados;
              },
              onEliminar: _eliminarRoles,
              onEditar: (rol) async {
                print('Editando rol: $rol');
                final resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) => RolesModal(
                    rolesController: widget.rolesController,
                    rol: rol,
                  ),
                );
                if (resultado == true) {
                  await _cargarRoles();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
