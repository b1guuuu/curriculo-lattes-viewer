class Trabalho {
  final int id;
  final String titulo;
  final int ano;
  final String tipo;
  final List<dynamic> nomes;
  final List<dynamic>? institutos;
  final List<dynamic>? pesquisadores;

  Trabalho(
      {required this.id,
      required this.titulo,
      required this.ano,
      required this.tipo,
      required this.nomes,
      required this.institutos,
      required this.pesquisadores});

  Trabalho.fromJson(dynamic json)
      : id = json['id'],
        titulo = json['titulo'],
        ano = json['ano'],
        tipo = json['tipo'],
        nomes = json['nomes'],
        institutos = json['institutos'],
        pesquisadores = json['pesquisadores'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "ano": ano,
      "tipo": tipo,
      "nomes": nomes.toString(),
      "pesquisadores": pesquisadores.toString(),
      "institutos": institutos.toString()
    };
  }

  String formataDetalhamento() {
    String autores = nomes.join(';');
    return '${autores.toUpperCase()}. $titulo. $ano.';
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
