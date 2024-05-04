import 'package:curriculo_lattes_viewer/src/models/nome_citacao.dart';

class Trabalho {
  final int id;
  final String titulo;
  final int ano;
  final String tipo;
  final String idPesquisador;
  final List<NomeCitacao> nomes;

  Trabalho(
      {required this.id,
      required this.titulo,
      required this.ano,
      required this.tipo,
      required this.idPesquisador,
      required this.nomes});

  Trabalho.fromJson(dynamic json)
      : id = json['id'],
        titulo = json['titulo'],
        ano = json['ano'],
        tipo = json['tipo'],
        idPesquisador = json['idPesquisador'],
        nomes = Trabalho.formataNomesFromJson(json['nomes']);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "ano": ano,
      "tipo": tipo,
      "idPesquisador": idPesquisador,
      "nomes": nomes.map((nome) => nome.toMap()).toList()
    };
  }

  String formataDetalhamento() {
    String autores = '';
    for (var nome in nomes) {
      autores += '${nome.nome.split(';').first};';
    }
    autores = autores.replaceRange(autores.length - 1, null, '');
    return '${autores.toUpperCase()}. $titulo. $ano.';
  }

  static List<NomeCitacao> formataNomesFromJson(json) {
    List<NomeCitacao> nomes = [];
    for (var nomeJson in json) {
      nomes.add(NomeCitacao.fromJson(nomeJson));
    }
    return nomes;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Trabalho ? other.id == id : false;
}
