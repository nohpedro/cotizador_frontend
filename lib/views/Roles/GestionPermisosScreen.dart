import 'package:flutter/material.dart';
import '../../controllers/PermissionController.dart';
import 'PermissionModal.dart';

class GestionPermisosScreen extends StatefulWidget {
  final PermissionController permissionController;

  const GestionPermisosScreen({Key? key, required this.permissionController}) : super(key: key);

  @override
  _GestionPermisosScreenState createState() => _GestionPermisosScreenState();
}

class _GestionPermisosScreenState extends State<GestionPermisosScreen> {
  final GlobalKey _tablaRolesConPermisosKey = GlobalKey();
  final GlobalKey _tablaRolesSinPermisosKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await widget.permissionController.fetchRolesWithPermissions();
    await widget.permissionController.fetchRolesWithoutPermissions();
    await widget.permissionController.fetchAllPermissions();
    setState(() {});
  }

  void _mostrarDialogoAsignarPermiso(int roleId) {
    showDialog(
      context: context,
      builder: (context) => PermissionModal(
        title: 'Seleccionar Permiso para Asignar',
        permissions: widget.permissionController.allPermissions,
        onSelected: (permissionId) async {
          final success = await widget.permissionController.assignPermission(roleId, permissionId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  void _mostrarDialogoEliminarPermiso(int roleId, List<dynamic> permisosActuales) {
    showDialog(
      context: context,
      builder: (context) => PermissionModal(
        title: 'Seleccionar Permiso para Eliminar',
        permissions: permisosActuales,
        onSelected: (permissionId) async {
          final success = await widget.permissionController.removePermission(roleId, permissionId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  Widget _crearTabla({
    required List<Map<String, dynamic>> roles,
    required bool conPermisos,
  }) {
    if (roles.isEmpty) {
      return const Center(child: Text('No hay roles disponibles.'));
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Rol')),
        if (conPermisos) DataColumn(label: Text('Permisos')),
        DataColumn(label: Text('Acciones')),
      ],
      rows: roles.map((rol) {
        final permisos = conPermisos
            ? (rol['permisos'] as List<dynamic>)
            .map((permiso) => permiso['name'])
            .join(', ')
            : null;

        return DataRow(cells: [
          DataCell(Text('${rol['id']}')),
          DataCell(Text(rol['name'])),
          if (conPermisos) DataCell(Text(permisos!)),
          DataCell(
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _mostrarDialogoAsignarPermiso(rol['id']),
                  child: const Text('Asignar'),
                ),
                if (conPermisos) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _mostrarDialogoEliminarPermiso(rol['id'], rol['permisos']),
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
        title: const Text('Gestión de Permisos'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      backgroundColor: const Color(0xFF2D2D3C),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Roles con Permisos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                roles: widget.permissionController.rolesWithPermissions,
                conPermisos: true,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Roles sin Permisos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                roles: widget.permissionController.rolesWithoutPermissions,
                conPermisos: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
