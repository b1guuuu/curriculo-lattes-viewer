import 'package:curriculo_lattes_viewer/src/views/pages/inicio.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/institutos.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/pesquisadores.dart';
import 'package:curriculo_lattes_viewer/src/views/pages/producao.dart';
import 'package:flutter/material.dart';

class Navegacao extends StatelessWidget {
  const Navegacao({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(child: Text('Curriculo Lattes Viewer')),
        ListTile(
          title: const Text('Inicio'),
          leading: const Icon(Icons.home_filled),
          onTap: () => Navigator.pushReplacementNamed(context, InicioPage.rota),
        ),
        ListTile(
          title: const Text('Institutos'),
          leading: const Icon(Icons.school),
          onTap: () =>
              Navigator.pushReplacementNamed(context, InstitutosPage.rota),
        ),
        ListTile(
          title: const Text('Pesquisadores'),
          leading: const Icon(Icons.people_alt),
          onTap: () =>
              Navigator.pushReplacementNamed(context, PesquisadoresPage.rota),
        ),
        ListTile(
          title: const Text('Produção'),
          leading: const Icon(Icons.local_library_rounded),
          onTap: () =>
              Navigator.pushReplacementNamed(context, ProducaoPage.rota),
        ),
      ],
    );
  }
}
