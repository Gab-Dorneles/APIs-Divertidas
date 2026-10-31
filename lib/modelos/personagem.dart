class Personagem {
  final int id;
  final String nome;
  final String status;
  final String especie;
  final String origem;
  final String imagem;

  Personagem({
    required this.id,
    required this.nome,
    required this.status,
    required this.especie,
    required this.origem,
    required this.imagem,
  });

  // Converte um item do JSON (Map) em objeto Personagem
  factory Personagem.fromMap(Map<String, dynamic> m) => Personagem(
    id: m['id'],
    nome: m['name'],
    status: m['status'],
    especie: m['species'],
    origem: m['origin']['name'],
    imagem: m['image'],
  );
}
