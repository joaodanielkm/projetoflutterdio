import 'package:flutter/material.dart';
import 'package:projetoflutterdio/ExchangeRateWidget.dart';
import 'package:projetoflutterdio/ExchangeService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('API de Cotação Flutter')),
        body: RefreshIndicator(
          onRefresh: () async {
            await ExchangeService.fetchExchangeRate();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const ExchangeRateWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
