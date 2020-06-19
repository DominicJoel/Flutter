

import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';



import 'package:formvalidation/src/models/producto_model.dart';

class ProductosProvider {

  final String _url = 'https://flutter-varios-faf06.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

   Future<bool> crearProducto ( ProductoModel producto ) async {

      final url = '$_url/productos.json?auth=${ _prefs.token }';

      final resp = await http.post( url, body: productoModelToJson(producto) );

      final decodeData = json.decode(resp.body);

      print(decodeData);

      return true;
   }

   Future<bool> editarProducto ( ProductoModel producto ) async {

      final url = '$_url/productos/${ producto.id }.json?auth=${ _prefs.token }';

      final resp = await http.put( url, body: productoModelToJson(producto) );

      final decodeData = json.decode(resp.body);

      print(decodeData);

      return true;

   }

   Future<List<ProductoModel>> cargarProductos () async {

      final url  = '$_url/productos.json?auth=${ _prefs.token }';
      final resp = await http.get( url );

      final Map<String, dynamic> decodeData = json.decode(resp.body); //Mapeamos los datos
      final List<ProductoModel> productos = new List();

      if( decodeData == null ) return [];

      if(decodeData['error'] != null) return [];// Si no viene error no retorne nada

      decodeData.forEach(( id, producto ) {
          final prodTemp = ProductoModel.fromJson(producto);
          prodTemp.id = id; // Le agregamos el ID al producto
          
          productos.add(prodTemp);
      });
      
      print(productos);

      return productos;

   }

    Future<int> borrarProductos ( String id ) async {

      final url  = '$_url/productos/$id.json?auth=${ _prefs.token }';
      
      final resp = await http.delete( url );

      print(json.decode(resp.body));

      return 1;
   }

    Future<String> subirImagen( File imagen ) async {
     // Sirve para subir cualquier tipo de archivo

       final url = Uri.parse('https://api.cloudinary.com/v1_1/da4a4esi1/image/upload?upload_preset=qeb2hgtn'); // Lo que sube la imagen
       final mimeType = mime(imagen.path).split('/'); // Capturar el tipo de imagen (//imagen/png)
       
       final imageUlploadRequest = http.MultipartRequest(
        'POST',
         url // En este caso el Url debe ser tipo Uri
       );

       final file = await http.MultipartFile.fromPath( // Para adjuntar archivo a la petición
          'file',
          imagen.path,
          contentType: new MediaType( mimeType[0] , mimeType[1])
         );

      imageUlploadRequest.files.add(file); //Así adjunta el archivo 
      
      final streamResponse = await imageUlploadRequest.send(); //Se dispara la petición
      final resp = await http.Response.fromStream(streamResponse); 

      if(resp.statusCode != 200 && resp.statusCode != 201){ // si no funciona
        print('Algo salio mal');
        print(resp.body);
        return null;
      }

      final respData = json.decode(resp.body);
      print(respData);
      return respData['secure_url'];
    }

}