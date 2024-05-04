class NomeCitacao {
  final int id;
  final String nome;
  final int idTrabalho;

  NomeCitacao({required this.id, required this.nome, required this.idTrabalho});
  NomeCitacao.fromJson(dynamic json)
      : id = json['id'],
        nome = json['nome'],
        idTrabalho = json['idTrabalho'];

  Map<String, dynamic> toMap() {
    return {"id": id, "nome": nome, "idTrabalho": idTrabalho};
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      other is NomeCitacao ? other.id == id : false;
}
