import 'dart:convert';

import 'package:curriculo_lattes_viewer/src/models/pesquisador.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PesquisadoresController {
  final String _baseURL = 'http://localhost:5000/pesquisador';

  Future<List<Pesquisador>> listar() async {
    Response respostaRequisicao = await http.get(Uri.parse('$_baseURL/listar'));
    var respostaJson = jsonDecode(respostaRequisicao.body);
    List<Pesquisador> pesquisadores = [];
    for (var pesquisadorJson in respostaJson) {
      pesquisadores.add(Pesquisador.fromJson(pesquisadorJson));
    }
    return pesquisadores;
  }

  Future<void> inserir(String id, int idInstituto) async {
    await http.post(Uri.parse('$_baseURL/inserir/$id/$idInstituto'));
  }

  Future<void> deletar(String id) async {
    await http.delete(Uri.parse('$_baseURL/deletar/$id'));
  }

  Future<List<Pesquisador>> filtrar(String? nomePesquisador,
      String? nomeInstituto, String? orderBy, String? sort) async {
    try {
      var uri = Uri.parse(
          '$_baseURL/filtrar?nomePesquisador=$nomePesquisador&nomeInstituto=$nomeInstituto&orderBy=$orderBy&sort=$sort');
      Response respostaRequisicao = await http.get(uri);
      var respostaJson = jsonDecode(respostaRequisicao.body);
      print(respostaJson.toString());
      List<Pesquisador> pesquisadores = [];
      for (var pesquisadorJson in respostaJson) {
        pesquisadores.add(Pesquisador.fromJson(pesquisadorJson));
      }
      return pesquisadores;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<String> buscarNomePesquisadorPorCodigo(
    String codigo,
  ) async {
    try {
      var uri = Uri.parse('$_baseURL/arquivo/$codigo');
      Response respostaRequisicao = await http.get(uri);
      var respostaJson = jsonDecode(respostaRequisicao.body);
      print(respostaJson.toString());
      return respostaJson['nome'].toString();
    } catch (e) {
      print(e.toString());
      return 'N/A';
    }
  }
}
