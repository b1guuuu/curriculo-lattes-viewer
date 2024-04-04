class Instituto {
  late int id;
  final String nome;
  final String acronimo;

  Instituto({required this.nome, required this.acronimo});

  Instituto.fromJson(dynamic json)
      : id = json['id'],
        nome = json['nome'],
        acronimo = json['acronimo'];

  Instituto.fromJsonSemId(dynamic json)
      : nome = json['nome'],
        acronimo = json['acronimo'];

  Map<String, dynamic> toMap() {
    return {"id": id, "nome": nome, "acronimo": acronimo};
  }

  Map<String, dynamic> toMapSemId() {
    return {"nome": nome, "acronimo": acronimo};
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Instituto ? other.id == id : false;
}
