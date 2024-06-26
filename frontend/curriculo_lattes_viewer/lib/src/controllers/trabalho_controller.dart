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

  Future<List<Trabalho>> listarRelacoes() async {
    Response resposta = await http.get(Uri.parse('$_baseURL/listar/relacoes'));
    var respostaJson = jsonDecode(resposta.body);
    List<Trabalho> trabalhos = [];
    for (var trabalhoJson in respostaJson) {
      trabalhos.add(Trabalho.fromJson(trabalhoJson));
    }
    return trabalhos;
  }

  Future<List<Trabalho>> filtrar(
      int? anoInicio,
      int? anoFim,
      int? idInstituto,
      String? idPesquisador,
      String? tipo,
      String? orderBy,
      String? sort,
      int posicaoInicial,
      int quantidadeItens) async {
    try {
      Response resposta = await http.get(Uri.parse(
          '$_baseURL/filtrar?anoInicio=$anoInicio&anoFim=$anoFim&idInstituto=$idInstituto&idPesquisador=$idPesquisador&tipo=$tipo&orderBy=$orderBy&sort=$sort&posicaoInicial=$posicaoInicial&quantidadeItens=$quantidadeItens'));
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

  Future<List<Trabalho>> filtrarAtualizado(
      int? anoInicio,
      int? anoFim,
      String? institutos,
      String? pesquisadores,
      String? tipo,
      String? orderBy,
      String? sort,
      int posicaoInicial,
      int quantidadeItens) async {
    try {
      Response resposta = await http.get(Uri.parse(
          '$_baseURL/filtrar/atualizado?anoInicio=$anoInicio&anoFim=$anoFim&institutos=$institutos&pesquisadores=$pesquisadores&tipo=$tipo&orderBy=$orderBy&sort=$sort&posicaoInicial=$posicaoInicial&quantidadeItens=$quantidadeItens'));
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

  Future<int> contar(
    int? anoInicio,
    int? anoFim,
    int? idInstituto,
    String? idPesquisador,
    String? tipo,
  ) async {
    try {
      var uri = Uri.parse(
          '$_baseURL/contar?anoInicio=$anoInicio&anoFim=$anoFim&idInstituto=$idInstituto&idPesquisador=$idPesquisador&tipo=$tipo');
      Response respostaRequisicao = await http.get(uri);
      var respostaJson = jsonDecode(respostaRequisicao.body);
      return respostaJson['totalTrabalhos'];
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<int> contarAtualizado(
    int? anoInicio,
    int? anoFim,
    String? institutos,
    String? pesquisadores,
    String? tipo,
  ) async {
    try {
      var uri = Uri.parse(
          '$_baseURL/contar/atualizado?anoInicio=$anoInicio&anoFim=$anoFim&institutos=$institutos&pesquisadores=$pesquisadores&tipo=$tipo');
      Response respostaRequisicao = await http.get(uri);
      var respostaJson = jsonDecode(respostaRequisicao.body);
      return respostaJson['totalTrabalhos'];
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}
