import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apis_imagens/main.dart';
import 'package:apis_imagens/telas/tela_caes.dart';
import 'package:apis_imagens/telas/tela_pokemon.dart';

void main() {
  testWidgets('home apresenta as aventuras e permite abrir a Pokédex', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Escolha sua aventura'), findsOneWidget);
    expect(find.text('Galeria de cães'), findsOneWidget);
    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.text('Personagens'), findsOneWidget);

    await tester.ensureVisible(find.text('Pokédex'));
    await tester.tap(find.text('Pokédex'));
    await tester.pumpAndSettle();

    expect(find.text('Nome ou número do Pokémon'), findsOneWidget);
  });

  testWidgets('carrossel inicial apresenta as três aventuras', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Adote seu cachorro'), findsOneWidget);
    expect(find.text('Ver cães'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-900, 0));
    await tester.pumpAndSettle();
    expect(find.text('Escolha seu Pokémon'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-900, 0));
    await tester.pumpAndSettle();
    expect(find.text('Encontre seu personagem'), findsOneWidget);
    expect(find.text('Ver personagens'), findsOneWidget);
  });

  testWidgets('galeria começa com uma foto brasileira creditada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TelaCaes()));

    await tester.ensureVisible(find.text('Sortear um cãozinho'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sortear um cãozinho'));
    await tester.pump();

    expect(find.text('Vira-lata caramelo · Brasil'), findsOneWidget);
    expect(find.textContaining('Wikimedia Commons'), findsOneWidget);

    final fotosSorteadas = <String>[
      (tester.widget<Image>(find.byType(Image)).image as NetworkImage).url,
    ];
    for (var i = 0; i < 4; i++) {
      await tester.ensureVisible(find.text('Sortear outro cãozinho'));
      await tester.pump();
      await tester.tap(find.text('Sortear outro cãozinho'));
      await tester.pump();
      fotosSorteadas.add(
        (tester.widget<Image>(find.byType(Image)).image as NetworkImage).url,
      );
    }

    expect(fotosSorteadas.toSet(), hasLength(5));
  });

  testWidgets('Pokédex mostra uma coleção colorida de Pokémon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TelaPokemon()));

    expect(find.text('Escolha seu Pokémon'), findsOneWidget);
    expect(find.text('20 para descobrir'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('Charmander'), findsOneWidget);
    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Nome ou número do Pokémon'), findsOneWidget);
  });
}
