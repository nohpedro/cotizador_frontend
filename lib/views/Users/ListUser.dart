import 'package:flutter/material.dart';
import '../../controllers/UserController.dart';
import '../../widgets/Buscador_widget.dart';
import '../../widgets/tabla_generica_widget.dart';
import 'EditUserModal.dart';

class ListUserScreen extends StatefulWidget {
  final UserController userController;

  const ListUserScreen({Key? key, required this.userController}) : super(key: key);

  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> usersOriginales = [];
  List<Map<String, dynamic>> usersFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    await widget.userController.fetchUsers();
    setState(() {
      usersOriginales = widget.userController.users.map((user) {
        return {
          'id': user['id'],
          'username': user['username'],
          'nombre': user['nombre'],
          'apellido': user['apellido'],
          'is_active': user['is_active'] ? 'Activo' : 'Inactivo',
        };
      }).toList();
      usersFiltrados = List.from(usersOriginales);
    });
  }

  void _filtrarUsuarios(String texto, String filtro) {
    setState(() {
      usersFiltrados = usersOriginales.where((user) {
        final valor = user[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarUsuarios(List<int> ids) async {
    for (var id in ids) {
      await widget.userController.deleteUser(id);
    }
    await _cargarUsuarios();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Usuarios'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'username', 'nombre', 'apellido', 'is_active'],
            onBuscar: _filtrarUsuarios,
          ),
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'USERNAME', 'NOMBRE', 'APELLIDO', 'ESTADO'],
              obtenerDatos: () async => usersFiltrados,
              onEliminar: _eliminarUsuarios,
              onEditar: (user) async {
                final resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) => EditUserModal(
                    userController: widget.userController,
                    user: user,
                  ),
                );

                if (resultado == true) {
                  await _cargarUsuarios();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
