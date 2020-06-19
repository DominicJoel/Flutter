import 'package:flutter/material.dart';

import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
// import 'package:formvalidation/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
 // final productoProvider = new ProductosProvider(); // Lo usaremos desde el bloc
 
  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page')
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

 
  Widget _crearListado( ProductosBloc productosBloc ){
    
     return StreamBuilder(
       stream: productosBloc.productosStream,
       builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
            if( snapshot.hasData ){
            final productos =  snapshot.data;
               return ListView.builder(
                     itemCount: productos.length,
                     itemBuilder: (context, i)  =>  _crearItem( productos[i], context, productosBloc ),
                 );
            }else{
              return Center(child: CircularProgressIndicator());
            }
       },
     );

      // Dejamos de usar el future builder
      // return FutureBuilder(
      //   future: productoProvider.cargarProductos(),
      //   builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
      //       if( snapshot.hasData ){
      //       final productos =  snapshot.data;
      //          return ListView.builder(
      //                itemCount: productos.length,
      //                itemBuilder: (context, i)  =>  _crearItem( productos[i], context ),
      //            );
      //       }else{
      //         return Center(child: CircularProgressIndicator());
      //       }
      //   },
      // );
  }

  Widget _crearItem( ProductoModel producto, BuildContext context, ProductosBloc productosBloc  ){
   
    return Dismissible( // Lo remueve 
         key: UniqueKey(),
         background: Container(
           color: Colors.red,
         ),
         onDismissed: ( direccion ) { // Cuando ejecute la función
              productosBloc.borrarProducto(producto.id);
              //productoProvider.borrarProductos(producto.id);
         },
         child: Card(
            child:Column(
              children: <Widget>[

                (producto.fotoUrl == null) 
                         ?  Image(image: AssetImage('assets/no-image.png'))
                         : FadeInImage(
                             image: NetworkImage( producto.fotoUrl ),
                             placeholder: AssetImage('assets/original.gif'),
                             height: 300.0,
                             width: double.infinity,
                             fit: BoxFit.cover,
                           ),

                      ListTile(
                        title: Text('${ producto.titulo } - ${ producto.valor }'),
                        subtitle: Text( producto.id ),
                        onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto) ,
                      ), 
              ],
            ),
           )
    );





  }

  _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  }
}