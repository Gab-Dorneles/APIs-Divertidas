import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({super.key});

  @override
  State<TelaPokemon> createState() => _TelaPokemonState();
}

class _TelaPokemonState extends State<TelaPokemon> {
  static const _pokemonEmDestaque = [
    _PokemonDestaque(1, 'Bulbasaur', Color(0xFF75B99A)),
    _PokemonDestaque(4, 'Charmander', Color(0xFFEE956D)),
    _PokemonDestaque(7, 'Squirtle', Color(0xFF72A8D8)),
    _PokemonDestaque(25, 'Pikachu', Color(0xFFE9BD4F)),
    _PokemonDestaque(39, 'Jigglypuff', Color(0xFFD98EB2)),
    _PokemonDestaque(52, 'Meowth', Color(0xFFD1A36D)),
    _PokemonDestaque(54, 'Psyduck', Color(0xFFD4B84F)),
    _PokemonDestaque(58, 'Growlithe', Color(0xFFE58B5B)),
    _PokemonDestaque(94, 'Gengar', Color(0xFF9575B8)),
    _PokemonDestaque(133, 'Eevee', Color(0xFFB88A69)),
    _PokemonDestaque(143, 'Snorlax', Color(0xFF688EAA)),
    _PokemonDestaque(150, 'Mewtwo', Color(0xFF9A8BC4)),
    _PokemonDestaque(152, 'Chikorita', Color(0xFF92B86B)),
    _PokemonDestaque(155, 'Cyndaquil', Color(0xFFE58A5F)),
    _PokemonDestaque(158, 'Totodile', Color(0xFF63AFC0)),
    _PokemonDestaque(196, 'Espeon', Color(0xFFD2789A)),
    _PokemonDestaque(197, 'Umbreon', Color(0xFF73758F)),
    _PokemonDestaque(252, 'Treecko', Color(0xFF76B58B)),
    _PokemonDestaque(255, 'Torchic', Color(0xFFE68164)),
    _PokemonDestaque(258, 'Mudkip', Color(0xFF6596C9)),
  ];

  final controle = TextEditingController();
  Map<String, dynamic>? pokemon;
  String? erro;
  bool carregando = false;

  Future<void> buscarPokemon([String? nome]) async {
    final busca = (nome ?? controle.text).trim().toLowerCase();
    if (busca.isEmpty) {
      setState(() {
        erro = 'Digite um nome ou número para buscar.';
        pokemon = null;
      });
      return;
    }
    controle.text = busca;
    FocusScope.of(context).unfocus();
    setState(() {
      carregando = true;
      erro = null;
      pokemon = null;
    });
    try {
      final resposta = await http.get(
        Uri.parse(
          'https://pokeapi.co/api/v2/pokemon/${Uri.encodeComponent(busca)}',
        ),
      );
      if (resposta.statusCode != 200) {
        throw Exception('Falha na consulta: ${resposta.statusCode}');
      }
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        pokemon = dados;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        erro = 'Não encontramos esse Pokémon. Confira o nome e tente de novo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F6FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF7F6FC),
      title: const Row(
        children: [
          Icon(Icons.catching_pokemon_rounded, color: Color(0xFFE45D69)),
          SizedBox(width: 8),
          Text('Pokédex', style: TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final colunas = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 600
            ? 3
            : 2;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _banner(),
                  const SizedBox(height: 22),
                  _campoBusca(),
                  if (carregando) ...[
                    const SizedBox(height: 18),
                    const LinearProgressIndicator(
                      color: Color(0xFFE45D69),
                      backgroundColor: Color(0xFFF4DDE0),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ],
                  if (erro != null) ...[
                    const SizedBox(height: 14),
                    _mensagemErro(),
                  ],
                  if (pokemon != null) ...[
                    const SizedBox(height: 20),
                    _cartaoDetalhes(),
                  ],
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Escolha seu Pokémon',
                          style: TextStyle(
                            color: Color(0xFF27253A),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${_pokemonEmDestaque.length} para descobrir',
                        style: const TextStyle(
                          color: Color(0xFF858397),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    itemCount: _pokemonEmDestaque.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final item = _pokemonEmDestaque[index];
                      return _cartaoPokemon(item);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  Widget _banner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE85F70), Color(0xFFF29170), Color(0xFFFFBD68)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFE85F70).withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 9),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SUA JORNADA COMEÇA AQUI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Encontre seu próximo parceiro!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Pesquise ou escolha um da coleção.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.catching_pokemon_rounded,
          color: Colors.white.withValues(alpha: 0.92),
          size: 62,
        ),
      ],
    ),
  );

  Widget _campoBusca() => Row(
    children: [
      Expanded(
        child: TextField(
          controller: controle,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => buscarPokemon(),
          decoration: InputDecoration(
            hintText: 'Nome ou número do Pokémon',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF8A879C),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFEAE8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFEAE8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE45D69),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: carregando ? null : () => buscarPokemon(),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF5546D7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
    ],
  );

  Widget _mensagemErro() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEEEE),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      erro!,
      style: const TextStyle(color: Color(0xFFAD3F48), fontSize: 13),
    ),
  );

  Widget _cartaoPokemon(_PokemonDestaque item) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: carregando ? null : () => buscarPokemon(item.id.toString()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 9,
                    child: Text(
                      '#${item.id.toString().padLeft(3, '0')}',
                      style: TextStyle(
                        color: item.cor.withValues(alpha: 0.85),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Center(
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item.id}.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.catching_pokemon_rounded,
                        color: item.cor,
                        size: 56,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 1, 12, 13),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF302E43),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.add_circle_rounded, color: item.cor, size: 19),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _cartaoDetalhes() {
    final dados = pokemon!;
    final sprites = dados['sprites'] as Map<String, dynamic>?;
    final otherSprites = sprites?['other'] as Map<String, dynamic>?;
    final officialArtwork =
        otherSprites?['official-artwork'] as Map<String, dynamic>?;
    final imagem =
        officialArtwork?['front_default'] ?? sprites?['front_default'];
    final tipos = (dados['types'] as List<dynamic>? ?? [])
        .map((item) => (item['type']['name'] as String).toUpperCase())
        .join('  ·  ');
    final nome = (dados['name'] as String).toUpperCase();
    final numero = (dados['id'] as int).toString().padLeft(3, '0');
    final altura = (dados['height'] as num) / 10;
    final peso = (dados['weight'] as num) / 10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFECE8FF), Color(0xFFF8E9F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5DFF7)),
      ),
      child: Row(
        children: [
          if (imagem is String)
            Image.network(
              imagem,
              width: 112,
              height: 112,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox(
                width: 112,
                height: 112,
                child: Icon(Icons.catching_pokemon_rounded, size: 56),
              ),
            )
          else
            const SizedBox(
              width: 112,
              height: 112,
              child: Icon(Icons.catching_pokemon_rounded, size: 56),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$numero',
                  style: const TextStyle(
                    color: Color(0xFF88849E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF302E43),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tipos,
                  style: const TextStyle(
                    color: Color(0xFF6E5CB3),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Altura  ${altura.toStringAsFixed(1)} m   ·   Peso  ${peso.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    color: Color(0xFF777487),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonDestaque {
  const _PokemonDestaque(this.id, this.nome, this.cor);

  final int id;
  final String nome;
  final Color cor;
}
