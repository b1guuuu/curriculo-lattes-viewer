import 'package:curriculo_lattes_viewer/src/controllers/estado_global_controller.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/institutos.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: EstadoGlobalController.instancia,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: ThemeData.dark(),
            initialRoute: InstitutosPage.rota,
            home: const InstitutosPage(),
            onGenerateRoute: (configuracoes) {
              return null;
              if (configuracoes.name == InstitutosPage.rota ||
                  configuracoes.name == '' ||
                  configuracoes.name == '/') {
                return MaterialPageRoute(builder: (context) {
                  return const InstitutosPage();
                });
              }

              assert(false, 'Need to implement ${configuracoes.name}');
              return null;
            },
          );
        });
  }
}
