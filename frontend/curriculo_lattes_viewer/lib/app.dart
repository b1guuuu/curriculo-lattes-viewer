import 'package:curriculo_lattes_viewer/src/views/pages/inicio.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/institutos.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/pesquisadores.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paged_datatable/paged_datatable.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        PagedDataTableLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en")],
      locale: const Locale("en"),
      title: 'Curriculo Lattes Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple, secondary: Colors.teal),
          cardTheme: CardTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))),
      home: const InicioPage(),
      routes: {
        InstitutosPage.rota: (context) => const InstitutosPage(),
        PesquisadoresPage.rota: (context) => const PesquisadoresPage()
      },
    );
  }
}
