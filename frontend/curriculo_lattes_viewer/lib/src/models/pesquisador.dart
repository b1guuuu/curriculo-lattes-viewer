class Pesquisador {
  final String? id;
  final String? nome;
  final String? nomeReferencia;
  final String? email;
  final int? idInstituto;

  Pesquisador(
      {required this.id,
      required this.nome,
      required this.nomeReferencia,
      required this.email,
      required this.idInstituto});

  Pesquisador.fromJson(dynamic json)
      : id = json['id'],
        nome = json['nome'],
        nomeReferencia = json['nomeReferencia'],
        email =
            (json['email']?.toString().isEmpty ?? false) ? json['email'] : '',
        idInstituto = json['idInstituto'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "nomeReferencia": nomeReferencia,
      "email": email,
      "idInstituto": idInstituto
    };
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
