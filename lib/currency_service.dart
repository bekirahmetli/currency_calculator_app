import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:currency_calculator_app/currency_model.dart';

class CurrencyService {
  Future<Map<String, dynamic>> fetchCurrencyData() async {
    final response = await http.get(Uri.parse('https://api.genelpara.com/embed/doviz.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Döviz kurları getirilemedi');
    }
  }

  Future<List<Currency>> fetchCurrencyList() async {
  final data = await fetchCurrencyData();
  List<Currency> list = [];
  data.forEach((key, value) {
    list.add(Currency(
      name: key,
      buyingPrice: value['alis'].toString(),
      sellingPrice: value['satis'].toString(),
      change: value['degisim'].toString(),
      changeDirection: value['d_yon'].toString(),
    ));
  });
  return list;
}
}