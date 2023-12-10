import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

List<int> generateLottoNumbers() {
  final random = Random();
  Set<int> lottoNumbers = {};
  while (lottoNumbers.length < 6) {
    lottoNumbers.add(random.nextInt(45) + 1);
  }
  return lottoNumbers.toList()
    ..sort();
}

final lottoNumberProvider = StateNotifierProvider<LottoNumberNotifier,
    List<int>>((ref) {
  return LottoNumberNotifier();
});

class LottoNumberNotifier extends StateNotifier<List<int>> {
  LottoNumberNotifier() : super([]);

  void generateNumbers() {
    state = generateLottoNumbers();
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lotto App with Hooks',
      home: LottoScreen(),
    );
  }
}

class LottoScreen extends HookConsumerWidget {
  const LottoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(lottoNumberProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lotto App with Hooks'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Lotto Numbers:',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
            Text(
              numbers.join(', '),
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(lottoNumberProvider.notifier).generateNumbers(),
              child: const Text('Generate Numbers'),
            ),
          ],
        ),
      ),
    );
  }
}