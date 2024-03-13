class Instituto {
  late int id;
  final String nome;
  final String acronimo;

  Instituto({required this.nome, required this.acronimo});

  Instituto.fromJson(dynamic json)
      : id = json[0],
        nome = json[1],
        acronimo = json[2];

  Instituto.fromJsonSemId(dynamic json)
      : nome = json[1],
        acronimo = json[2];

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
