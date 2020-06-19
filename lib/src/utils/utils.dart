import 'package:flutter/material.dart';
//Archivos para clases generales

bool isNumeric(String s) {
    
    if(s.isEmpty) return false; // Si esta vacio retorna nulo

    final n = num.tryParse(s); //Saber si se puede parsear a un número

    return ( n == null ) ? false : true;
}


void mostrarAlerta(BuildContext context, String mensaje) {
   
   showDialog(
     context: context,
     builder: ( context ) {
       return AlertDialog(
         title: Text('Información incorrecta'),
         content: Text(mensaje),
         actions: <Widget>[
           FlatButton(
             onPressed: () => Navigator.of(context).pop(), 
             child: Text('OK')
             )
         ],
       );
     }
    );


  
}


