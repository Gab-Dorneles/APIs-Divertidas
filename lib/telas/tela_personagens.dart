import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modelos/personagem.dart';
import 'tela_detalhe_personagem.dart';

class TelaPersonagens extends StatefulWidget {
  const TelaPersonagens({super.key});

  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  late Future<List<Personagem>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = buscarPersonagens(); // pede os dados UMA vez, ao abrir a tela
  }

  Future<List<Personagem>> buscarPersonagens() async {
    final resposta = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character?page=1'));
    if (resposta.statusCode != 200) {
      throw Exception('Falha na consulta: ${resposta.statusCode}');
    }
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final lista = dados['results'] as List<dynamic>;
    return lista
        .map((item) => Personagem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  void _recarregar() {
    setState(() { _futuro = buscarPersonagens(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body: FutureBuilder<List<Personagem>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Não foi possível carregar os personagens.'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _recarregar,
                  child: const Text('Tentar de novo')),
              ]),
            );
          }
          final personagens = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: personagens.length,
            itemBuilder: (context, i) {
              final p = personagens[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(p.imagem)),
                  title: Text(p.nome),
                  subtitle: Text('${p.especie} · ${p.status}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>
                      TelaDetalhePersonagem(personagem: p))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
