import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report/src/feature/state/my_notifier.dart';
import 'package:report/src/local/local.dart';

class RepoDrawer extends StatefulWidget {
  const RepoDrawer({super.key});

  @override
  State<RepoDrawer> createState() => _RepoDrawerState();
}

class _RepoDrawerState extends State<RepoDrawer> {
  final _preferences = SharedPreferencesSingleton();

  String? selectedLanguage;
  // Holds the selected language
  final List<String> languages = ['Anglè', 'Fansè', 'Panyòl'];
  // Language options

  @override
  Widget build(BuildContext context) {
    bool notification = _preferences.getNotification();
    final activated = Provider.of<MyNotifier>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'konfigiration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SwitchListTile.adaptive(
            value: notification,
            title: const Text('Notifikasyon'),
            onChanged: (value) {
              setState(() {
                value = !value;
              });
              _preferences.enableNotification(!value);
            },
          ),
          SwitchListTile.adaptive(
            value: activated.timer,
            title: const Text('Aktive konte a'),
            onChanged: (value) {
              setState(() {
                value = !value;
              });
              activated.activateTimer(!value);
            },
          ),
          const ListTile(leading: Text(''), title: Text('Pran sevis Pyonye 📝'),),
          DropdownButton<String>(
            value: selectedLanguage, // Current selected language
            hint:
                const Text('Chwazi yon Lang'), // Initial hint before selection
            items: languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue; // Update selected language
              });
            },
          ),
        ],
      ),
    );
  }
}
