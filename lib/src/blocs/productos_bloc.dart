

import 'dart:io';

import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/producto_model.dart';


// Esto nos funciona para que podamos usar la info y redibujarla en cualquier parte del sistema
class ProductosBloc {

  final _productosController = new BehaviorSubject<List<ProductoModel>>(); //El StreamController
  final _cargandoController = new BehaviorSubject<bool>(); //El StreamController


  final _productosoProvider  = new ProductosProvider(); // La idea con esto es que lo maneje desde aquí el provider siempre
   

   // Escuchar el Stream
   Stream<List<ProductoModel>> get productosStream => _productosController.stream;
   Stream<bool> get cargando => _cargandoController.stream;
   

   // La llamada de los providers agregandolo a nuestro Stream
   void cargarProductos() async  {
     final productos = await _productosoProvider.cargarProductos();

     _productosController.sink.add( productos );
   }

   void agregarProducto(ProductoModel producto) async {
     _cargandoController.sink.add(true); //Indicamos que estamos cargando
     await _productosoProvider.crearProducto(producto);
     _cargandoController.sink.add(false); //Indicamos que estamos cargando  
   }

    Future<String> subirFoto(File foto) async {
     _cargandoController.sink.add(true); //Indicamos que estamos cargando
     final fotoUrl = await _productosoProvider.subirImagen(foto);
     _cargandoController.sink.add(false); //Indicamos que estamos cargando  
     
     return fotoUrl;
    }


   void editarProducto(ProductoModel producto) async {

     _cargandoController.sink.add(true); //Indicamos que estamos cargando
     await _productosoProvider.editarProducto(producto);
     _cargandoController.sink.add(false); //Indicamos que estamos cargando  

    }

    void borrarProducto(String id) async {
     
     //No ponemos la función de _cargandoController porque el diseño que usamos hace esa simulación al momento de eliminar
      await _productosoProvider.borrarProductos(id); 

    }

  dispose() {
    //Validamos que exista y cerramos el Stream
    _productosController?.close();
    _cargandoController?.close();
  }

}