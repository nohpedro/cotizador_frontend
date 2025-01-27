import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/service/PlanchasService.dart';
import 'package:frontendweb_flutter/service/ProoveedorService.dart';
import 'controllers/plancha_controller.dart';
import 'model/AuthHandler.dart';
import 'model/RequestHandler.dart';
import 'views/home_page.dart';

void main() async{
  runApp(const MyApp());
  //AuthService auth =  AuthService();
  //await auth.Login('admin','admin');
  //final String? token = await auth.getToken();




  //await authHandler.initialize();

  //PlanchaService fuck = PlanchaService(espesor: 12, largo: 12, ancho: 12, precioValor: 12, proveedorId: 2, authHandler: authHandler);







  //MANEJODE DE PROVEEDORES EJEMPLO//
  /*
  PlanchaService plancha = PlanchaService(espesor: 10, largo: 3000, ancho: 1500, precioValor: 1000, proveedorId: 1);
  plancha.CreacionPlancha(token!);
  List<Map<String, dynamic>>? PLanchaLista = await PlanchaService.GetPlanchas(token);
  for(var planchas in PLanchaLista!){
  print(planchas['id']);
  }
  */


  //MANEJO DE PROVEEDORES EJEMPLO///
  //ProveedorService proveedor = ProveedorService(nombre: 'Las Lomas');
  //await proveedor.AgregarProveedor(token!);
  /*List<Map<String, dynamic>>? listaProveedores = await ProveedorService.ObtenerProveedores(token!);
  print('Lista de proveedores: $listaProveedores');
  for (var proveedor in listaProveedores!) {
   print('ID: ${proveedor['id']}, Nombre: ${proveedor['nombre']}');
  }*/



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metalize - 8-bit Style',
      theme: ThemeData.dark(),
      home: HomePage(
        imageUrl: 'assets/images/metalize.png',
      ),
    );
  }
}
