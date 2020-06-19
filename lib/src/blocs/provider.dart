// MyApp recordar que esta es la principal de todo

// Implementamos un InheritedWidget para usarlo de manera globa; en nuestro codigo

import 'package:flutter/material.dart';

import 'package:formvalidation/src/blocs/login_bloc.dart';
export 'package:formvalidation/src/blocs/login_bloc.dart'; // Para exportarlo en donde usemos el provider

import 'package:formvalidation/src/blocs/productos_bloc.dart';
export 'package:formvalidation/src/blocs/productos_bloc.dart'; // Para exportarlo en donde usemos el provider

class Provider extends InheritedWidget{

   final loginBloc      = new LoginBloc();
   final _productosBloc = new ProductosBloc();

  
  static Provider _instancia; // Esto es para en vez de crear una nueva instancia mantenga la anterior si ya fue creada
    
    factory Provider({ Key key, Widget child }) { // Con esto lo hacemos singleton
      if(_instancia == null){
         _instancia = new Provider._internal(key: key, child:child); // Con esto prevenimos que se instancie desde afuera
      }

      return _instancia;
    }
  
  Provider._internal({ Key key, Widget child }) // Key es la llave unica que le pondremos al widget
   : super(key: key, child: child);

  // Provider({ Key key, Widget child }) // Key es la llave unica que le pondremos al widget
  //  :super(key: key, child: child);

  @override //Para saber si al modificarse le indique a sus hijos
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // En el 99% de los casos siempre será true

  static LoginBloc of ( BuildContext context ){
      return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc; // retornaa la instancia del loginBloc
           //Lo que haece es que dentro del contexto busca un widget del tipo provider 
   }

     static ProductosBloc productosBloc ( BuildContext context ){ // Este productosBloc es diferente al _productosBloc que tenemos como general 
      return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc; // retornaa la instancia del loginBloc
           //Lo que haece es que dentro del contexto busca un widget del tipo provider
   
   }

}