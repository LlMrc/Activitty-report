import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/screen/repport_screen.dart';
import '../screen/pyonye_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    bool notification = _preferences.getNotification();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text(
          //     'konfigiration',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 24,
          //     ),
          //   ),
          // ),
          Container(
              alignment: Alignment.bottomCenter,
              color: Theme.of(context).colorScheme.secondaryFixedDim,
              height: 100,
              child: Text(
                'Konfigirasyon'.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    letterSpacing: 1),
              )),
              const SizedBox(height: 16),
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
          ListTile(
              leading: const Icon(Icons.file_copy_outlined),
              title: const Text('Sèvis Pyonye'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.restorablePushNamed(
                    context, PyonyeServicesDataPicker.routeName);
              }),
          ExpansionTile(
            collapsedBackgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHigh,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: const Text('Chwazi yon lang'),
            leading: const Icon(Icons.translate_outlined),
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  highlightColor: Colors.black45,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: const Text("Fransè"),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: const Text("Anglè"),
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text("Panyòl"),
                ),
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Rapò'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.restorablePushNamed(context, RepportScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
