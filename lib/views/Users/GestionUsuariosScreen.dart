import 'package:flutter/material.dart';
import '../../controllers/UserRoleController.dart';
import 'UserRoleModal.dart';

class GestionUsuariosScreen extends StatefulWidget {
  final UserRoleController userRoleController;

  const GestionUsuariosScreen({Key? key, required this.userRoleController}) : super(key: key);

  @override
  _GestionUsuariosScreenState createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await widget.userRoleController.fetchUsersWithRoles();
    await widget.userRoleController.fetchUsersWithoutRoles();
    await widget.userRoleController.fetchRoles();
    setState(() {});
  }

  void _mostrarDialogoAsignarRol(int userId) async {
    await widget.userRoleController.fetchRoles(); // Cargar roles
    showDialog(
      context: context,
      builder: (context) => UserRoleModal(
        title: 'Seleccionar Rol para Asignar',
        roles: widget.userRoleController.roles,
        onSelected: (roleId) async {
          final success = await widget.userRoleController.assignRoleToUser(userId, roleId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  void _mostrarDialogoEliminarRol(int userId, List<dynamic> rolesActuales) {
    showDialog(
      context: context,
      builder: (context) => UserRoleModal(
        title: 'Seleccionar Rol para Eliminar',
        roles: rolesActuales,
        onSelected: (roleId) async {
          final success = await widget.userRoleController.removeRoleFromUser(userId, roleId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  Widget _crearTabla({
    required List<Map<String, dynamic>> usuarios,
    required bool conRoles,
  }) {
    if (usuarios.isEmpty) {
      return const Center(child: Text('No hay usuarios disponibles.'));
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Usuario')),
        DataColumn(label: Text('Nombre')),
        if (conRoles) DataColumn(label: Text('Roles')),
        DataColumn(label: Text('Acciones')),
      ],
      rows: usuarios.map((usuario) {
        final roles = conRoles
            ? (usuario['roles'] as List<dynamic>)
            .map((rol) => rol['name'])
            .join(', ')
            : null;

        return DataRow(cells: [
          DataCell(Text('${usuario['id']}')),
          DataCell(Text(usuario['username'])),
          DataCell(Text('${usuario['nombre']} ${usuario['apellido']}')),
          if (conRoles) DataCell(Text(roles!)),
          DataCell(
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _mostrarDialogoAsignarRol(usuario['id']),
                  child: const Text('Asignar'),
                ),
                if (conRoles) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _mostrarDialogoEliminarRol(usuario['id'], usuario['roles']),
                    child: const Text('Eliminar'),
                  ),
                ],
              ],
            ),
          ),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Roles de Usuarios'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      backgroundColor: const Color(0xFF2D2D3C),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Usuarios con Roles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                usuarios: widget.userRoleController.usersWithRoles,
                conRoles: true,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Usuarios sin Roles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                usuarios: widget.userRoleController.usersWithoutRoles,
                conRoles: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
