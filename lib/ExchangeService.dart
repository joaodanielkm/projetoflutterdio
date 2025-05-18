import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeService {
  static const String _cacheKey = 'last_exchange_data';

  static Future<Map<String, dynamic>> fetchExchangeRate() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://economia.awesomeapi.com.br/json/last/USD-BRL'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveToCache(data); // Salva no cache
        return data;
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      final cachedData = await _getFromCache();
      if (cachedData != null) {
        return cachedData; // Retorna cache se houver
      } else {
        throw Exception('Sem conexão e nenhum dado em cache');
      }
    }
  }

  static Future<void> _saveToCache(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, json.encode(data));
  }

  static Future<Map<String, dynamic>?> _getFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    return cachedData != null ? json.decode(cachedData) : null;
  }
}
