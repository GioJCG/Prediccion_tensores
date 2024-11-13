import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

const String loginPostMutation = """
mutation TokenAuth(\$username: String!, \$password: String!){
  tokenAuth(username: \$username,password: \$password) {
    token
  }
}
""";

class LoginPage extends StatelessWidget {
  // Definimos los controladores de texto
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userNameController, 
              decoration:
                  InputDecoration(hintText: 'Ingrese su nombre de usuario'),
            ),
            TextField(
              controller: passwordController, 
              decoration: InputDecoration(hintText: 'Ingrese su contraseña'),
            ),
            Mutation(
              options: MutationOptions(
                document: gql(loginPostMutation),
                // ignore: void_checks
                update: (cache, result) {
                  return cache;
                },
                onCompleted: (result) {
                  if (result == null) {
                    print('Completed with errors');
                  } else {
                    print('ok ...');
                    appState.username = userNameController.text;
                    appState.token = result["tokenAuth"]["token"].toString();
                    print(result["tokenAuth"]["token"]);
                  }
                },
                onError: (error) {
                  print('error :');
                  appState.error = error!.graphqlErrors[0].message.toString();
                  print(error.graphqlErrors[0].message);
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  onPressed: () {
                    // Ejecutamos la mutación con los valores ingresados
                    runMutation({
                      "username": userNameController.text,
                      "password": passwordController.text
                    });
                  },
                  child: const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
