import 'package:curriculo_lattes_viewer/src/controllers/intitutos_controller.dart';
import 'package:flutter/material.dart';

class InformacoesInstitutoDialog extends StatelessWidget {
  final InstitutosController _controller = InstitutosController();
  final TextEditingController codigoTFController;
  final TextEditingController nomeTFController;
  final TextEditingController acronimoTFController;

  InformacoesInstitutoDialog(
      {super.key,
      required this.codigoTFController,
      required this.nomeTFController,
      required this.acronimoTFController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Instituto'),
      content: SizedBox(
        width: 700,
        height: 250,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Código', border: OutlineInputBorder()),
              readOnly: true,
              controller: codigoTFController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Nome', border: OutlineInputBorder()),
              controller: nomeTFController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Acronimo', border: OutlineInputBorder()),
              controller: acronimoTFController,
              maxLength: 10,
            )
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () async {
            if (codigoTFController.value.text.isEmpty) {
              await _controller.inserir(
                  nomeTFController.value.text, acronimoTFController.value.text);
            } else {
              await _controller.atualizar(int.parse(codigoTFController.text),
                  nomeTFController.value.text, acronimoTFController.value.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Gravar'),
        ),
        FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
      ],
    );
  }
}
