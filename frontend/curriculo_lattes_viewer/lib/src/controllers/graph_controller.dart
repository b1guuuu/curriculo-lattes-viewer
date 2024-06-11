import 'dart:convert';
import 'package:http/http.dart' as http;

class GraphController {
  final String _baseURL = 'http://localhost:5000/grafo';

  Future<dynamic> gerarGrafo(Map<String, dynamic> options) async {
    final resposta = await http.post(Uri.parse(_baseURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(options));

    if (resposta.statusCode != 200) {
      throw Exception(
          'Ocorreu um erro ao inserir o curso: ${jsonDecode(resposta.body)}');
    }

    return resposta.bodyBytes;
  }
}
