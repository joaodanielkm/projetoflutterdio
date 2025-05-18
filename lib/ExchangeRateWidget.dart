import 'package:flutter/material.dart';
import 'package:projetoflutterdio/ExchangeService.dart';

class ExchangeRateWidget extends StatefulWidget {
  const ExchangeRateWidget({super.key});

  @override
  State<ExchangeRateWidget> createState() => _ExchangeRateWidgetState();
}

class _ExchangeRateWidgetState extends State<ExchangeRateWidget> {
  Future<Map<String, dynamic>>? _exchangeData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _exchangeData = ExchangeService.fetchExchangeRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: _exchangeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  Text('Erro: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              );
            } else {
              final data = snapshot.data!['USDBRL'];
              return Column(
                children: [
                  Text(
                    'Dólar para Real',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Compra: R\$ ${data['bid']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Venda: R\$ ${data['ask']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loadData,
          child: const Text('Atualizar Cotação'),
        ),
      ],
    );
  }
}
