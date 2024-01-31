import 'package:flutter/material.dart';
import 'package:currency_calculator_app/currency_service.dart';
import 'package:currency_calculator_app/currency_model.dart';
import 'package:currency_calculator_app/settings_page.dart';
import 'package:currency_calculator_app/currency_calculator_page.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatefulWidget {
  const CurrencyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyAppState createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  final CurrencyService currencyService = CurrencyService();

  ThemeData appThemeData = ThemeData.light();

  void updateAppTheme(ThemeData themeData) {
    setState(() {
      appThemeData = themeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Döviz Kurları'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Ana Sayfa'),
                Tab(text: 'Döviz Hesaplama'),
                Tab(text: 'Ayarlar'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: currencyService.fetchCurrencyData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else {
                    final data = snapshot.data;
                    final currencyList = parseCurrencyData(data);
                    return ListView.builder(
                      itemCount: currencyList.length,
                      itemBuilder: (context, index) {
                        final currency = currencyList[index];
                        return ListTile(
                          title: Text(currency.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alış: ${currency.buyingPrice}'),
                              Text('Satış: ${currency.sellingPrice}'),
                              Text('Değişim: ${currency.change} (${currency.changeDirection})'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),

              const CurrencyCalculatorPage(),

              SettingsPage(
                updateTheme: updateAppTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Currency> parseCurrencyData(Map<String, dynamic>? data) {
    List<Currency> currencyList = [];
    if (data != null) {
      data.forEach((key, value) {
        final name = key;
        final buyingPrice = value['alis'];
        final sellingPrice = value['satis'];
        final change = value['degisim'];
        final changeDirection = value['d_yon'];
        currencyList.add(Currency(
          name: name,
          buyingPrice: buyingPrice,
          sellingPrice: sellingPrice,
          change: change,
          changeDirection: changeDirection ?? "",
        ));
      });
    }
    return currencyList;
  }
}