import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

String linkPostMutation = """
mutation CreateLink(\$url: String!, \$description: String!){
  createLink(url: \$url, description: \$description) {
    url
    description
  }
}
""";

class SeguimientoPage extends StatelessWidget {
  
final descriptionController = TextEditingController();
final linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.token.isEmpty) {
      return Center(
        child: Text("No login yet"),
      );
    }
        return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento'),
      ),
      body: Center(
         child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: descriptionController,
              decoration:
                  InputDecoration(hintText: 'Ingrese la descripcion del link'),
            ),
            TextField(
              controller: linkController,
              decoration: InputDecoration(hintText: 'Ingrese su link'),
            ),
            Mutation(
               options: MutationOptions(
                 document: gql(linkPostMutation),
                 // ignore: void_checks
                 update: (cache, result) {
                     return cache;
                 },
                 onCompleted: (result) {
                 if (result == null) {
                      print('Completed with errors ');
                   }  else {
                     print('ok ...');
                     result["createLink"]["url"];
                     result["createLink"]["description"];
                   }
                 },
                 onError: (error)  {
                   print('error :');
                   appState.error = error!.graphqlErrors[0].message.toString();
                   print(error.graphqlErrors[0].message);
                 },

               ),
               builder: ( runMutation,  result) {

                 return ElevatedButton(
                 onPressed: ()  {
                   // ignore: await_only_futures
                   runMutation({ "description": 'description',
                                  "url": 'link'
                                 });
                 },
                 child: const Text('Guardar registro'),
                  );
               }          
           ),
          ],
        ),
      ),
    ),
   );
  }
}


