import 'dart:convert';

import 'package:curriculo_lattes_viewer/src/models/intituto.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class InstitutosController {
  final String _baseURL = 'http://localhost:5000/instituto';

  Future<List<Instituto>> listar() async {
    Response respostaRequisicao = await http.get(Uri.parse('$_baseURL/listar'));
    var respostaJson = jsonDecode(respostaRequisicao.body);
    List<Instituto> institutos = [];
    for (var institutoJson in respostaJson) {
      institutos.add(Instituto.fromJson(institutoJson));
    }
    return institutos;
  }

  Future<void> inserir(String nome, String acronimo) async {
    await http.post(Uri.parse('$_baseURL/inserir/$nome/$acronimo'));
  }

  Future<void> atualizar(int id, String nome, String acronimo) async {
    await http.put(Uri.parse('$_baseURL/atualizar/$id/$nome/$acronimo'));
  }

  Future<void> deletar(int id) async {
    await http.delete(Uri.parse('$_baseURL/deletar/$id'));
  }

  Future<List<Instituto>> filtrar(
      String? nome, String? acronimo, String? orderBy, String? sort) async {
    try {
      var uri = Uri.parse(
          '$_baseURL/filtrar?nome=$nome&acronimo=$acronimo&orderBy=$orderBy&sort=$sort');
      Response respostaRequisicao = await http.get(uri);
      var respostaJson = jsonDecode(respostaRequisicao.body);
      List<Instituto> institutos = [];
      for (var institutoJson in respostaJson) {
        institutos.add(Instituto.fromJson(institutoJson));
      }
      return institutos;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
