import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/provider.dart';

import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:formvalidation/src/pages/registro_page.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {
  final prefs = new PreferenciasUsuario();
  runApp(MyApp());
  await prefs.initPrefs();
  
  
} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider( // Este provider como es un inheritedWidget nos permite manejar la informacion en cualquiera de sus hijos que venga del inherited
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login'     : (BuildContext context ) => LoginPage(),
          'registro'     : (BuildContext context ) => RegistroPage(),
          'home'      : (BuildContext context ) => HomePage(),
          'producto'  : (BuildContext context ) => ProductoPage()
        },
        theme: ThemeData( // Cambiamos el color primario de la aplicacion
          primaryColor: Colors.deepPurple
        ),
     )
    );// lo ponemos aqui porq esta es la que usamos como clase padre

  }
}