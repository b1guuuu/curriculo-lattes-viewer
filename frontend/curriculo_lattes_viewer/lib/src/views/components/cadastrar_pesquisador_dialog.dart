import 'package:curriculo_lattes_viewer/src/controllers/pesquisadores_controller.dart';
import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CadastrarPesquisadorDialog extends StatefulWidget {
  final List<Instituto> institutos;

  const CadastrarPesquisadorDialog({super.key, required this.institutos});

  @override
  State<StatefulWidget> createState() {
    return CadastrarPesquisadorDialogState();
  }
}

class CadastrarPesquisadorDialogState
    extends State<CadastrarPesquisadorDialog> {
  final PesquisadoresController _controller = PesquisadoresController();
  final TextEditingController _idTFController = TextEditingController();
  late Instituto? _institutoSelecionado;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Pesquisador'),
      content: SizedBox(
        height: 500,
        width: 400,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  label: Text('Informe o novo ID'),
                  border: OutlineInputBorder()),
              controller: _idTFController,
            ),
            const SizedBox(
              height: 15,
            ),
            Autocomplete<Instituto>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Instituto>.empty();
                }
                return widget.institutos.where((instituto) =>
                    instituto.nome
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()) ||
                    instituto.acronimo
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (instituto) {
                setState(() {
                  _institutoSelecionado = instituto;
                });
              },
              displayStringForOption: (instituto) =>
                  '${instituto.acronimo} - ${instituto.nome}',
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  TextField(
                decoration: const InputDecoration(
                    label: Text('Instituto'),
                    hintText: 'Digite o nome ou acronimo do instituto',
                    border: OutlineInputBorder()),
                controller: textEditingController,
                focusNode: focusNode,
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () async {
            if (_idTFController.text.isEmpty) {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: 'Valor inválido',
                  text: 'O campo ID está vazio',
                  confirmBtnText: 'Fechar');
            } else {
              if (_institutoSelecionado == null) {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: 'Valor inválido',
                    text: 'Não foi selecionado um instituto',
                    confirmBtnText: 'Fechar');
              } else {
                try {
                  var nomePesquisador = await _controller
                      .buscarNomePesquisadorPorCodigo(_idTFController.text);

                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text:
                          'Deseja mesmo incluir o Lattes ${_idTFController.text} de $nomePesquisador em ${_institutoSelecionado!.nome}?',
                      confirmBtnText: 'Confirmar',
                      cancelBtnText: 'Cancelar',
                      confirmBtnColor: Colors.green,
                      title: 'Você tem certeza?',
                      onConfirmBtnTap: () async {
                        try {
                          await _controller.inserir(
                              _idTFController.text, _institutoSelecionado!.id);
                          Navigator.pop(context, true);
                        } catch (e) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: e.toString(),
                            confirmBtnText: 'Confirmar',
                            cancelBtnText: 'Cancelar',
                            confirmBtnColor: Colors.green,
                            title: 'Erro ao inserir pesquisador',
                          );
                        }
                      }).then((gravou) {
                    if (gravou == true) Navigator.pop(context);
                  });
                } catch (e) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: e.toString(),
                    confirmBtnText: 'Confirmar',
                    cancelBtnText: 'Cancelar',
                    confirmBtnColor: Colors.green,
                    title: 'Erro ao inserir pesquisador',
                  );
                }
              }
            }
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
