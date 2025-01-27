import 'package:flutter/material.dart';
import '../../widgets/Buscador_widget.dart';
import '../../widgets/tabla_generica_widget.dart';
import '../../controllers/plancha_controller.dart';
import 'PlanchasEdit.dart';

class PlanchaScreen extends StatefulWidget {
  final PlanchaController planchaController;

  const PlanchaScreen({Key? key, required this.planchaController}) : super(key: key);

  @override
  _PlanchaScreenState createState() => _PlanchaScreenState();
}

class _PlanchaScreenState extends State<PlanchaScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> planchasOriginales = [];
  List<Map<String, dynamic>> planchasFiltradas = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarPlanchas();
  }

  /// Carga la lista de planchas desde el controlador
  Future<void> _cargarPlanchas() async {
    print('=== _cargarPlanchas INVOKED ===');
    try {
      // Llamamos al método que obtiene los datos (puede hacer un fetch a la API).
      await widget.planchaController.fetchPlanchas();

      // Imprimimos la lista "cruda" tal como viene del controlador
      print('Datos de planchaController.planchas: ${widget.planchaController.planchas}');

      setState(() {
        // Mapeamos cada plancha a un nuevo formato (Map<String, dynamic>).
        planchasOriginales = widget.planchaController.planchas.map((plancha) {
          print('Mapeando plancha: $plancha'); // Debug de cada elemento

          return {
            'id': int.parse(plancha['id'].toString()), // Convertir ID a entero
            'espesor': plancha['espesor'],
            'largo': plancha['largo'],
            'ancho': plancha['ancho'],
            'precio': plancha['precio'], // Cambiado de precio_valor a precio
            'proveedor': plancha['proveedor']['nombre'],
          };
        }).toList();

        // Copiamos la lista original a la filtrada
        planchasFiltradas = List.from(planchasOriginales);
      });

      print('=== _cargarPlanchas COMPLETED ===');
    } catch (e) {
      print('Error al cargar las planchas: $e');
    }
  }


  /// Filtra la lista de planchas según [texto] y [filtro].
  void _filtrarPlanchas(String texto, String filtro) {
    print('=== _filtrarPlanchas INVOKED ===');
    print('Texto a filtrar: $texto, Filtro: $filtro');
    setState(() {
      planchasFiltradas = planchasOriginales.where((plancha) {
        final valor = filtro == 'proveedor'
            ? plancha['proveedor'].toString().toLowerCase()
            : plancha[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
    print('Resultado de planchasFiltradas: $planchasFiltradas');
  }

  /// Elimina las planchas dadas por [ids].
  Future<void> _eliminarPlanchas(List<int> ids) async {
    print('=== _eliminarPlanchas INVOKED con ids: $ids ===');
    for (var id in ids) {
      print('Eliminando plancha con id: $id');
      await widget.planchaController.eliminarPlancha(id);
    }
    // Recargamos la tabla
    await _cargarPlanchas();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    // Podemos imprimir el estado actual cada vez que se construye la pantalla:
    print('=== PlanchaScreen.build() INVOKED ===');
    print('Cantidad de planchasFiltradas: ${planchasFiltradas.length}');

    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Planchas'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          // Buscador
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'espesor', 'largo', 'ancho', 'precio_valor', 'proveedor'],
            onBuscar: _filtrarPlanchas,
          ),
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'ESPESOR', 'LARGO', 'ANCHO', 'PRECIO', 'PROVEEDOR'],
              obtenerDatos: () async {
                print('TablaGenericaWidget.obtenerDatos INVOKED: retornando planchasFiltradas');
                return planchasFiltradas;
              },
              onEliminar: _eliminarPlanchas,
              onEditar: (plancha) async {
                // Prints para verificar qué llega en "plancha"
                print('=== onEditar Invocado ===');
                print('Plancha completa: $plancha');
                print('Tipo de plancha["id"]: ${plancha["id"]?.runtimeType}');

                // Si plancha["proveedor"] fuera un String (nombre) en lugar de un Map,
                // aquí daría error. Asegúrate de que sea un Map en tu tabla si lo usas así:
                // plancha['proveedor']['id'].
                print('Tipo de plancha["proveedor"]: ${plancha["proveedor"]?.runtimeType}');

                // Controladores de texto con valores iniciales
                final espesorController = TextEditingController(
                  text: plancha['espesor'].toString(),
                );
                final largoController = TextEditingController(
                  text: plancha['largo'].toString(),
                );
                final anchoController = TextEditingController(
                  text: plancha['ancho'].toString(),
                );
                final precioController = TextEditingController(
                  // Asegúrate de usar 'precio_valor' en lugar de 'precio'
                  // si así se llama tu campo real.
                  text: plancha['precio_valor'].toString(),
                );

                // Aquí asumimos que plancha['proveedor'] es un Mapa
                // con la clave 'id'. Si plancha['proveedor'] es un String,
                // hay que cambiar la lógica.
                final proveedorValor = plancha['proveedor']['id'];
                print('Proveedor ID antes de int.tryParse: $proveedorValor');
                int? proveedorSeleccionado = int.tryParse(proveedorValor.toString());
                print('Proveedor ID parseado como int: $proveedorSeleccionado');

                // Mostramos el diálogo
                final bool? resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return EditPlanchaModal(
                      espesorController: espesorController,
                      largoController: largoController,
                      anchoController: anchoController,
                      precioController: precioController,
                      proveedorSeleccionado: proveedorSeleccionado,
                      authHandler: widget.planchaController.authHandler,
                      onProveedorChanged: (nuevoProveedor) {
                        print('onProveedorChanged invocado. Nuevo proveedor: $nuevoProveedor');
                        proveedorSeleccionado = nuevoProveedor;
                      },
                      onSave: () async {
                        print('==== Guardando cambios ====');

                        final nuevosDatos = {
                          'espesor': double.tryParse(espesorController.text) ?? 0,
                          'largo': int.tryParse(largoController.text) ?? 0,
                          'ancho': int.tryParse(anchoController.text) ?? 0,
                          'proveedor_id': proveedorSeleccionado,
                          'precio_valor': double.tryParse(precioController.text) ?? 0,
                        };
                        print('nuevosDatos: $nuevosDatos');

                        final planchaIdStr = plancha['id'].toString();
                        print('ID de la plancha (como String): $planchaIdStr');
                        final id = int.tryParse(planchaIdStr);
                        print('ID parseado como int: $id');

                        if (id != null) {
                          print('Llamando a editarPlancha...');
                          final success = await widget.planchaController.editarPlancha(id, nuevosDatos);
                          print('Resultado de editarPlancha: $success');
                          Navigator.pop(context, success);
                        } else {
                          print('No se pudo parsear el ID de la plancha a int');
                          Navigator.pop(context, false);
                        }
                      },
                      onCancel: () {
                        print('Edición cancelada por el usuario');
                        Navigator.pop(context, false);
                      },
                    );
                  },
                );

                print('Diálogo cerrado. Resultado: $resultado');

                // Si la edición fue exitosa, recargamos la lista
                if (resultado == true) {
                  await _cargarPlanchas();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
