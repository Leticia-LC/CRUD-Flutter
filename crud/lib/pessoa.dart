class Pessoa {
  int? id;
  String? nome;
  int? idade;

  Pessoa({this.id, this.nome, this.idade});

  Map<String, dynamic> toMap() {
    var mapa = <String, dynamic>{
      'nome': nome,
      'idade': idade,
    };
    if (id != null) {
      mapa['id'] = id;
    }
    return mapa;
  }

  Pessoa.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    nome = mapa['nome'];
    idade = mapa['idade'];
  }
}
