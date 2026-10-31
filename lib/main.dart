import 'dart:async';

import 'package:flutter/material.dart';

import 'telas/tela_caes.dart';
import 'telas/tela_pokemon.dart';
import 'telas/tela_personagens.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'APIs Divertidas',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5546D7),
        surface: const Color(0xFFF7F8FC),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F8FC),
        foregroundColor: Color(0xFF20213A),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    ),
    home: const TelaInicial(),
  );
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final aventuras = [
      _Aventura(
        titulo: 'Galeria de cães',
        descricao: 'Conheça um novo amigo a cada clique.',
        icone: Icons.pets_rounded,
        cor: const Color(0xFFE88B43),
        corFundo: const Color(0xFFFFF1E5),
        destino: const TelaCaes(),
      ),
      _Aventura(
        titulo: 'Pokédex',
        descricao: 'Pesquise Pokémon por nome ou número.',
        icone: Icons.catching_pokemon_rounded,
        cor: const Color(0xFFE35462),
        corFundo: const Color(0xFFFFEAEC),
        destino: const TelaPokemon(),
      ),
      _Aventura(
        titulo: 'Personagens',
        descricao: 'Explore o universo de Rick and Morty.',
        icone: Icons.auto_awesome_rounded,
        cor: const Color(0xFF39A98A),
        corFundo: const Color(0xFFE5F6F0),
        destino: const TelaPersonagens(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF5546D7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.explore_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            const Text(
              'APIs DIVERTIDAS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final emGrade = constraints.maxWidth >= 700;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CarrosselInicial(),
                    const SizedBox(height: 34),
                    Text(
                      'Escolha sua aventura',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF20213A),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Um toque e algo novo para descobrir.',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: const Color(0xFF73758A)),
                    ),
                    const SizedBox(height: 20),
                    if (emGrade)
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final aventura in aventuras)
                            _CardAventura(aventura: aventura, emGrade: true),
                        ],
                      )
                    else
                      Column(
                        children: [
                          for (final aventura in aventuras) ...[
                            _CardAventura(aventura: aventura),
                            if (aventura != aventuras.last)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CarrosselInicial extends StatefulWidget {
  const _CarrosselInicial();

  @override
  State<_CarrosselInicial> createState() => _CarrosselInicialState();
}

class _CarrosselInicialState extends State<_CarrosselInicial> {
  static const _slides = [
    _SlideInicial(
      titulo: 'Adote seu cachorro',
      descricao: 'Conheça cães cheios de carinho esperando por você.',
      chamada: 'Ver cães',
      imagem: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/55/Cachorro_esperando_na_ado%C3%A7%C3%A3o_20240623.jpg/960px-Cachorro_esperando_na_ado%C3%A7%C3%A3o_20240623.jpg',
      corInicial: Color(0xFFCB653B),
      corFinal: Color(0xFFF0A45D),
      destino: TelaCaes(),
    ),
    _SlideInicial(
      titulo: 'Escolha seu Pokémon',
      descricao: 'Encontre seu parceiro e descubra toda a coleção.',
      chamada: 'Abrir Pokédex',
      imagem: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
      corInicial: Color(0xFFB94C5B),
      corFinal: Color(0xFFEC9B58),
      imagemContida: true,
      destino: TelaPokemon(),
    ),
    _SlideInicial(
      titulo: 'Encontre seu personagem',
      descricao: 'Viaje pelo universo maluco de Rick and Morty.',
      chamada: 'Ver personagens',
      imagem: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      corInicial: Color(0xFF248C76),
      corFinal: Color(0xFF8AAB53),
      destino: TelaPersonagens(),
    ),
  ];

  final _controller = PageController();
  Timer? _timer;
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_controller.hasClients) return;
      final proximaPagina = (_paginaAtual + 1) % _slides.length;
      _controller.animateToPage(
        proximaPagina,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (pagina) => setState(() => _paginaAtual = pagina),
            itemBuilder: (context, index) => _cardSlide(_slides[index]),
          ),
        ),
      ),
      const SizedBox(height: 13),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_slides.length, (index) {
          final selecionado = index == _paginaAtual;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: selecionado ? 24 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: selecionado
                  ? const Color(0xFF5546D7)
                  : const Color(0xFFD8D8E4),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    ],
  );

  Widget _cardSlide(_SlideInicial slide) => Stack(
    fit: StackFit.expand,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [slide.corInicial, slide.corFinal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: 230,
        child: Image.network(
          slide.imagem,
          fit: slide.imagemContida ? BoxFit.contain : BoxFit.cover,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white70,
              size: 72,
            ),
          ),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              slide.corInicial.withValues(alpha: 0.98),
              slide.corInicial.withValues(alpha: 0.9),
              slide.corInicial.withValues(alpha: 0.12),
            ],
            stops: const [0, 0.5, 1],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(23, 22, 130, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'DESCUBRA SUA PRÓXIMA AVENTURA',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              slide.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              slide.descricao,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 37,
              child: FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => slide.destino),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: slide.corInicial,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(slide.chamada),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _SlideInicial {
  const _SlideInicial({
    required this.titulo,
    required this.descricao,
    required this.chamada,
    required this.imagem,
    required this.corInicial,
    required this.corFinal,
    required this.destino,
    this.imagemContida = false,
  });

  final String titulo;
  final String descricao;
  final String chamada;
  final String imagem;
  final Color corInicial;
  final Color corFinal;
  final Widget destino;
  final bool imagemContida;
}

class _Aventura {
  const _Aventura({
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.corFundo,
    required this.destino,
  });

  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;
  final Color corFundo;
  final Widget destino;
}

class _CardAventura extends StatelessWidget {
  const _CardAventura({required this.aventura, this.emGrade = false});

  final _Aventura aventura;
  final bool emGrade;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Color(0xFFEAEBF2)),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => aventura.destino),
      ),
      child: Padding(
        padding: EdgeInsets.all(emGrade ? 20 : 16),
        child: emGrade ? _conteudoEmGrade(context) : _conteudoEmLinha(context),
      ),
    ),
  );

  Widget _conteudoEmLinha(BuildContext context) => Row(
    children: [
      _icone(),
      const SizedBox(width: 16),
      Expanded(child: _textos(context)),
      const SizedBox(width: 8),
      const Icon(
        Icons.arrow_forward_rounded,
        color: Color(0xFF9A9BAD),
        size: 21,
      ),
    ],
  );

  Widget _conteudoEmGrade(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icone(),
          const Icon(
            Icons.arrow_outward_rounded,
            color: Color(0xFF9A9BAD),
            size: 20,
          ),
        ],
      ),
      const Spacer(),
      _textos(context),
    ],
  );

  Widget _icone() => Container(
    width: 54,
    height: 54,
    decoration: BoxDecoration(
      color: aventura.corFundo,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Icon(aventura.icone, color: aventura.cor, size: 28),
  );

  Widget _textos(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        aventura.titulo,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF24253C),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        aventura.descricao,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: const Color(0xFF77798D), height: 1.4),
      ),
    ],
  );
}
