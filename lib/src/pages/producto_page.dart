import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/productos_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/producto_model.dart';
// import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;


class ProductoPage extends StatefulWidget {
   
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
   final formKey     = GlobalKey<FormState>(); // El key de los formularios
   final scaffoldKey = GlobalKey<ScaffoldState>(); // El key del scaffold es obligatorio para poder hacer el snack
   
  // final productoProvider = new ProductosProvider();
   
   ProductosBloc productosBloc;
   ProductoModel producto = new ProductoModel();
   bool _guardando = false; //Para que sepa que el formulario es valido para grabar
   File foto;
  
  @override
  Widget build(BuildContext context) {
    //Aqui se construye las cosas por primera vez

    productosBloc = Provider.productosBloc(context);



    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;// Capturar la data que mandamos por la URL
    
    if( prodData != null ){ // Si tiene data lo igualamos al producto que iniciamos
        producto = prodData;
    }
     
    return Scaffold(
      key:scaffoldKey,
      appBar:AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ),
            onPressed: _tomarFoto,
          )
        ]
      ) ,

      body: SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.all(15.0),
          child: Form( 
            key: formKey , //id unico que nos permitira hacer referencia al form
            child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              ),
           )
        ),
      ),
    );
  }

  Widget _crearNombre(){
     
     return TextFormField(
       initialValue: producto.titulo, //Valor inicial del textField
       textCapitalization: TextCapitalization.sentences,
       decoration: InputDecoration(
         labelText: 'Producto'
       ),
       onSaved: (value) => producto.titulo = value, // Aqui le asignamos el valor del textField al modelo, solo se ejucta despues del validator
       validator: (value) {
          if(value.length < 3){
            return 'Ingrese el nombre del producto';
          }else{
            return null; // Aqui decimos que funciona
          }
       },
     ); // Este a diferencia del textInput , trabaja directamente con un formulario

  }

  Widget _crearPrecio(){
     return TextFormField(
       initialValue: producto.valor.toString(), //Valor inicial del textField y debe ser String 
       keyboardType: TextInputType.number, // El tipo de texto que recibirá
       decoration: InputDecoration(
         labelText: 'Precio'
       ),
       onSaved: (value) => producto.valor = double.parse(value), // Aqui le asignamos el valor del textField al modelo, solo se ejucta despues del validator
       validator: (value) { // Validar que sea un número
        if( utils.isNumeric(value) ){ //Si es verdadero es porque es correcto
          return null;
        }else{
          return 'Sólo números';
        }
       },
     ); // Este a diferencia del textInput , trabaja directamente con un formulario
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: producto.disponible, 
      activeColor: Colors.deepPurple,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        producto.disponible = value;
      })
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      icon: Icon(Icons.save), 
      label: Text('Guardar'),
      color: Colors.deepPurple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ) ,
      onPressed: ( _guardando ) ? null : _submit, 
      );
  }

  void _submit() async {
    
    if( !formKey.currentState.validate() ) return ; //para que valide lo que existe en el formulario
   
     formKey.currentState.save(); // Esto dispara todo los save de los textField , debe ir despues de la validación asi no guarda uno con error
    
     setState(() {
       _guardando = true;    
     });

     //Subir Imagen

     if( foto != null ){
      producto.fotoUrl = await productosBloc.subirFoto(foto);
     }
    
    // Crear o actualizar
    if( producto.id == null ){
     // productoProvider.crearProducto(producto);
      productosBloc.agregarProducto(producto);
    }else{
      //  productoProvider.editarProducto(producto);
       productosBloc.editarProducto(producto);
    }

      setState(() { //Si llega aquí es porque se redibujó nuevamente
       _guardando = false;    
      });
    
     mostrarSnackBar('Registro guardado');

     Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje){
    final snackbar = SnackBar(
      duration: Duration(milliseconds: 15000),
      backgroundColor: Colors.deepPurple,
      content:  Text(mensaje),
      );

      scaffoldKey.currentState.showSnackBar(snackbar); //Es obligatorio para que funcione usar el scaffold
  }

 Widget _mostrarFoto(){
   
   if( producto.fotoUrl != null ){
     return FadeInImage(
          image: NetworkImage( producto.fotoUrl ),
          placeholder: AssetImage('assets/original.gif'),
          height: 300.0,
          fit: BoxFit.contain,
       );
   }else { 
     return Image(
       image: AssetImage( foto?.path ?? 'assets/no-image.png'), //Si tiene algo muestra , pero si no tiene nada pone la del assets
       height: 300.0,
       fit: BoxFit.cover,
     );
   }
 }
 
  _seleccionarFoto() async {
     _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async { 
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage( // Esto retorna un future
      source: origen // De donde quiero la info
    );

    if( foto != null ){
      // Si seleccionamos una foto y ya tenia una foto antes
      producto.fotoUrl = null;
    }

    setState(() {}); //Para que se redibuje el widget cuando seleccione la foto
  }
}
