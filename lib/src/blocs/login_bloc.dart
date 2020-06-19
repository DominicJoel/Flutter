
import 'dart:async';
import 'package:formvalidation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

   // final _emailController = StreamController<String>.broadcast(); // Cada vez que le demos a un input pasara por ahí
   // final _passwordController = StreamController<String>.broadcast(); // Cada vez que le demos a un input pasara por ahí

   final _emailController    = BehaviorSubject<String>(); // Cada vez que le demos a un input pasara por ahí hace lo mismo que el StreamController y nos permite que podamos trabajar con la libreria rxdart
   final _passwordController = BehaviorSubject<String>(); // Cada vez que le demos a un input pasara por ahí

   // Recuperar los datos del Stream
   Stream<String> get emailStream    => _emailController.stream.transform( validarEmail ); //Lo escuchamos
   Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword ); //Lo escuchamos
    
   Stream<bool> get formValidStream =>  // Para que cuando ambos sean validos lo haga valido
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

   //Insertar valores al Stream
   Function(String) get changeEmail    => _emailController.sink.add; // No la ejecutamos con los () solo hacemos referencias
   Function(String) get changePassword => _passwordController.sink.add; // No la ejecutamos con los () solo hacemos referencias


   // Obtener el último valor ingresado a los streams
   String get email => _emailController.value;
   String get password => _passwordController.value;


   dispose() {
     _emailController?.close();
     _passwordController?.close();
   }

}