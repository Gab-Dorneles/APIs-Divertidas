import 'dart:math' as math;

import 'package:flutter/material.dart';

class TelaCaes extends StatefulWidget {
  const TelaCaes({super.key});

  @override
  State<TelaCaes> createState() => _TelaCaesState();
}

class _TelaCaesState extends State<TelaCaes> {
  static const _fotosCachorros = [
    _FotoCao(
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/55/Cachorro_esperando_na_ado%C3%A7%C3%A3o_20240623.jpg/960px-Cachorro_esperando_na_ado%C3%A7%C3%A3o_20240623.jpg',
      'Tet · CC0',
      'Bento',
      3,
      'Vira-lata caramelo · Brasil',
    ),
    _FotoCao(
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/50/Caramelo_dog_59.jpg/960px-Caramelo_dog_59.jpg',
      'Vitor Coelho Nisida · domínio público',
      'Amora',
      2,
      'Vira-lata caramelo · Brasil',
    ),
    _FotoCao(
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/82/01_puppy_portrait_Kim_8_weeks.jpg/960px-01_puppy_portrait_Kim_8_weeks.jpg',
      'Marilyn Peddle · CC BY 2.0',
      'Luna',
      1,
      'Filhote',
    ),
    _FotoCao(
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/33/Callie_the_golden_retriever_puppy.jpg/960px-Callie_the_golden_retriever_puppy.jpg',
      'MichaelMcPhee · CC BY 3.0',
      'Callie',
      1,
      'Golden Retriever',
    ),
    _FotoCao(
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/96/Keeshond_Siberian_Husky_crossbreed_puppy.jpg/960px-Keeshond_Siberian_Husky_crossbreed_puppy.jpg',
      'Richard Bartz · CC BY-SA 2.5',
      'Tobias',
      2,
      'Keeshond · Husky',
    ),
  ];

  final List<_FotoCao> _filaFotos = [];
  String? imagem;
  String? creditoImagem;
  String? etiquetaImagem;
  String? nome;
  int? idade;
  String? erro;
  bool carregando = false;

  void buscarCao() {
    setState(() {
      carregando = true;
      erro = null;
    });
    if (_filaFotos.isEmpty) {
      _filaFotos.addAll(
        List<_FotoCao>.of(_fotosCachorros)..shuffle(math.Random()),
      );
      if (imagem == null && !_filaFotos.first.etiqueta.contains('Vira-lata')) {
        final indiceViraLata = _filaFotos.indexWhere(
          (foto) => foto.etiqueta.contains('Vira-lata'),
        );
        final primeiraFoto = _filaFotos[0];
        _filaFotos[0] = _filaFotos[indiceViraLata];
        _filaFotos[indiceViraLata] = primeiraFoto;
      }
    }

    if (_filaFotos.first.url == imagem) {
      final alternativa = 1 + math.Random().nextInt(_filaFotos.length - 1);
      final primeiraFoto = _filaFotos[0];
      _filaFotos[0] = _filaFotos[alternativa];
      _filaFotos[alternativa] = primeiraFoto;
    }

    final foto = _filaFotos.removeAt(0);
    setState(() {
      imagem = foto.url;
      creditoImagem = '${foto.credito} · Wikimedia Commons';
      etiquetaImagem = foto.etiqueta;
      nome = foto.nome;
      idade = foto.idade;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Galeria de cães',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    body: LayoutBuilder(
      builder: (context, constraints) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Um novo amigo te espera',
                  style: TextStyle(
                    color: Color(0xFF27253A),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Cada sorteio traz um cão diferente, sem repetir até mostrar todos.',
                  style: TextStyle(
                    color: Color(0xFF777687),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEBF1)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF292344).withValues(alpha: 0.06),
                        blurRadius: 22,
                        offset: const Offset(0, 9),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: math.min(constraints.maxWidth * 0.68, 330),
                        child: imagem == null
                            ? _imagemInicial()
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    imagem!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return _carregandoImagem();
                                        },
                                    errorBuilder: (_, _, _) =>
                                        _imagemIndisponivel(),
                                  ),
                                  Positioned(
                                    top: 14,
                                    left: 14,
                                    child: _etiquetaOrigem(),
                                  ),
                                ],
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (nome != null && idade != null) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      nome!,
                                      style: const TextStyle(
                                        color: Color(0xFF27253A),
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  _etiquetaIdade(idade!),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Pronto para ser seu novo melhor amigo.',
                                style: TextStyle(
                                  color: Color(0xFF777687),
                                  fontSize: 13,
                                ),
                              ),
                            ] else
                              const Text(
                                'Seu próximo melhor amigo',
                                style: TextStyle(
                                  color: Color(0xFF27253A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (creditoImagem != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Foto: $creditoImagem',
                                style: const TextStyle(
                                  color: Color(0xFF888697),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            if (erro != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                erro!,
                                style: const TextStyle(
                                  color: Color(0xFFB3261E),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton.icon(
                                onPressed: carregando ? null : buscarCao,
                                icon: carregando
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.casino_rounded),
                                label: Text(
                                  carregando
                                      ? 'Buscando um cãozinho...'
                                      : imagem == null
                                      ? 'Sortear um cãozinho'
                                      : 'Sortear outro cãozinho',
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF5546D7),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Nomes e idades são fictícios 🐾',
                    style: TextStyle(color: Color(0xFF888697), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _etiquetaIdade(int anos) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1E5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      '$anos ${anos == 1 ? 'ano' : 'anos'}',
      style: const TextStyle(
        color: Color(0xFFB56328),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _imagemInicial() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFFFF4E9), Color(0xFFF1EDFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets_rounded, color: Color(0xFFE88B43), size: 64),
        SizedBox(height: 12),
        Text(
          'Quem será seu próximo amigo?',
          style: TextStyle(
            color: Color(0xFF777687),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _etiquetaOrigem() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          etiquetaImagem?.contains('Vira-lata') == true
              ? Icons.location_on_rounded
              : Icons.pets_rounded,
          color: const Color(0xFF5546D7),
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          etiquetaImagem ?? 'Cãozinho surpresa',
          style: const TextStyle(
            color: Color(0xFF39364E),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _carregandoImagem() => const ColoredBox(
    color: Color(0xFFF3F1FA),
    child: Center(child: CircularProgressIndicator(color: Color(0xFF5546D7))),
  );

  Widget _imagemIndisponivel() => const ColoredBox(
    color: Color(0xFFF3F1FA),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF888697),
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            'Imagem indisponível',
            style: TextStyle(color: Color(0xFF777687)),
          ),
        ],
      ),
    ),
  );
}

class _FotoCao {
  const _FotoCao(this.url, this.credito, this.nome, this.idade, this.etiqueta);

  final String url;
  final String credito;
  final String nome;
  final int idade;
  final String etiqueta;
}
