import 'dart:convert';

import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class InstitutosController {
  final String _baseURL = 'http://localhost:5000/instituto';

  Future<List<Instituto>> listar() async {
    Response respostaRequisicao = await http.get(Uri.parse('$_baseURL/listar'));
    var respostaJson = jsonDecode(respostaRequisicao.body);
    print(respostaJson);
    List<Instituto> institutos = [];
    for (var institutoJson in respostaJson) {
      institutos.add(Instituto.fromJson(institutoJson));
    }
    return institutos;
  }

  Future<void> inserir(String nome, String acronimo) async {
    await http.post(Uri.parse('$_baseURL/inserir/$nome/$acronimo'));
  }

  Future<void> deletar(int id) async {
    await http.delete(Uri.parse('$_baseURL/deletar/$id'));
  }
}
