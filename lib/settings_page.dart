import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final void Function(ThemeData themeData) updateTheme;

  const SettingsPage({super.key, required this.updateTheme});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedColor = 'Açık Tema';
  ThemeData themeData = ThemeData.light();

  @override
  void initState() {
    super.initState();
    loadThemeFromPrefs();
  }

  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selectedColor');
    if (savedTheme != null) {
      setState(() {
        selectedColor = savedTheme;
      });
      updateThemeData(selectedColor);
    }
  }

  void updateThemeData(String selectedColor) {
    switch (selectedColor) {
      case 'Açık Tema':
        themeData = ThemeData.light();
        break;
      case 'Koyu Tema':
        themeData = ThemeData.dark();
        break;
      case 'Kırmızı':
        themeData = ThemeData(primarySwatch: Colors.red);
        break;
      case 'Yeşil':
        themeData = ThemeData(primarySwatch: Colors.green);
        break;
      case 'Mor':
        themeData = ThemeData(primarySwatch: Colors.purple);
        break;
      case 'Indigo':
        themeData = ThemeData(primarySwatch: Colors.indigo);
        break;
      default:
        themeData = ThemeData.light();
    }
    widget.updateTheme(themeData);
    saveThemeToPrefs(selectedColor);
  }

  Future<void> saveThemeToPrefs(String selectedColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedColor', selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema Seçimi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildColorOption('Açık Tema'),
            buildColorOption('Koyu Tema'),
            buildColorOption('Kırmızı'),
            buildColorOption('Yeşil'),
            buildColorOption('Mor'),
            buildColorOption('Indigo'),
          ],
        ),
      ),
    );
  }

  Widget buildColorOption(String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: label,
        groupValue: selectedColor,
        onChanged: (String? value) {
          setState(() {
            selectedColor = value!;
            updateThemeData(selectedColor);
          });
        },
      ),
    );
  }
}