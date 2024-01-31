import 'package:flutter/material.dart';
import 'package:currency_calculator_app/currency_model.dart';
import 'package:currency_calculator_app/currency_service.dart';

class CurrencyCalculatorPage extends StatefulWidget {
  const CurrencyCalculatorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyCalculatorPageState createState() => _CurrencyCalculatorPageState();
}

class _CurrencyCalculatorPageState extends State<CurrencyCalculatorPage> {
  final CurrencyService currencyService = CurrencyService();

  String selectedFromCurrency = 'USD';
  String selectedToCurrency = 'EUR';
  double amount = 1.0;
  String convertedAmount = '0.00';

  List<Currency> currencyList = [];

  @override
  void initState() {
    super.initState();
    currencyService.fetchCurrencyList().then((list) {
      setState(() {
        currencyList = list;
      });
    });
  }

  void calculateConversion() {
    double? fromRate = getExchangeRate(selectedFromCurrency);
    double? toRate = getExchangeRate(selectedToCurrency);

    if (fromRate != null && toRate != null) {
      double result = (amount * fromRate) / toRate;

      setState(() {
        convertedAmount = result.toStringAsFixed(4);
      });
    } else {
      setState(() {
        convertedAmount = '0.0000';
      });
    }
  }

  double? getExchangeRate(String currencyName) {
    for (Currency currency in currencyList) {
      if (currency.name == currencyName) {
        return double.tryParse(currency.buyingPrice);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Döviz Miktarı:'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '1.0',
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 1.0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Dönüştürülen Döviz Birimleri:'),
                DropdownButton<String>(
                  value: selectedFromCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedFromCurrency = value!;
                    });
                  },
                  items: currencyList.map((currency) {
                    return DropdownMenuItem(
                      value: currency.name,
                      child: Text(currency.name),
                    );
                  }).toList(),
                ),
                const Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: selectedToCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedToCurrency = value!;
                    });
                  },
                  items: currencyList.map((currency) {
                    return DropdownMenuItem(
                      value: currency.name,
                      child: Text(currency.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    calculateConversion();
                  },
                  child: const Text('Dönüştür'),
                ),
                const SizedBox(height: 20),
                Text('Sonuç: $convertedAmount $selectedToCurrency'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}