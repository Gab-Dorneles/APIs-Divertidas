import 'package:flutter/material.dart';
import '../modelos/personagem.dart';

class TelaDetalhePersonagem extends StatelessWidget {
  final Personagem personagem;
  const TelaDetalhePersonagem({super.key, required this.personagem});

  Color _corStatus() {
    switch (personagem.status) {
      case 'Alive': return Colors.green;
      case 'Dead': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(personagem.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(personagem.imagem,
              width: 240, height: 240, fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                const Icon(Icons.broken_image, size: 120)),
          ),
          const SizedBox(height: 16),
          Text(personagem.nome,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(Icons.circle, size: 12, color: _corStatus()),
            label: Text(personagem.status),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Espécie'),
            subtitle: Text(personagem.especie)),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Origem'),
            subtitle: Text(personagem.origem)),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('ID'),
            subtitle: Text('${personagem.id}')),
        ]),
      ),
    );
  }
}
