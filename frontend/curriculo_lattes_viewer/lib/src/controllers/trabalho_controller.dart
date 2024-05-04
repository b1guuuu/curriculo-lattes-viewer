import 'dart:convert';

import 'package:curriculo_lattes_viewer/src/models/trabalho.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TrabalhoController {
  final String _baseURL = 'http://localhost:5000/trabalho';

  Future<List<Trabalho>> listar() async {
    Response resposta = await http.get(Uri.parse('$_baseURL/listar'));
    var respostaJson = jsonDecode(resposta.body);
    List<Trabalho> trabalhos = [];
    for (var trabalhoJson in respostaJson) {
      trabalhos.add(Trabalho.fromJson(trabalhoJson));
    }
    return trabalhos;
  }

  Future<List<Trabalho>> filtrar() async {
    try {
      Response resposta = await http.get(Uri.parse('$_baseURL/filtrar'));
      var respostaJson = jsonDecode(resposta.body);
      List<Trabalho> trabalhos = [];
      for (var trabalhoJson in respostaJson) {
        trabalhos.add(Trabalho.fromJson(trabalhoJson));
      }
      return trabalhos;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
