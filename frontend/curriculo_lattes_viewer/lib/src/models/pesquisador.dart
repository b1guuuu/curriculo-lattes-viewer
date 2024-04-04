class Pesquisador {
  late String id;
  late String nome;
  late String email;
  final int idInstituto;

  Pesquisador({required this.id, required this.idInstituto});

  Pesquisador.fromJson(dynamic json)
      : id = json['id'],
        nome = json['nome'],
        email =
            (json['email']?.toString().isEmpty ?? false) ? json['email'] : '',
        idInstituto = json['idInstituto'];

  Pesquisador.fromJsonSemId(dynamic json)
      : nome = json['nome'],
        email = json['email'],
        idInstituto = json['idInstituto'];

  Map<String, dynamic> toMap() {
    return {"id": id, "nome": nome, "email": email, "idInstituto": idInstituto};
  }

  Map<String, dynamic> toMapSemId() {
    return {"nome": nome, "email": email, "idInstituto": idInstituto};
  }

  Map<String, dynamic> toMapCadastro() {
    return {"id": id, "idInstituto": idInstituto};
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Pesquisador ? other.id == id : false;
}
