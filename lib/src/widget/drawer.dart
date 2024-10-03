import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/screen/repport_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screen/pyonye_screen.dart';

class RepoDrawer extends StatefulWidget {
  const RepoDrawer({super.key});

  @override
  State<RepoDrawer> createState() => _RepoDrawerState();
}

class _RepoDrawerState extends State<RepoDrawer> {
  final _preferences = SharedPreferencesSingleton();

  String? selectedLanguage;

  //Panyòl
  // final List<String> languages = [
  //   AppLocalizations.of(context)!.eng,
  //   AppLocalizations.of(context)!.fr,
  //   AppLocalizations.of(context)!.es
  // ];
  @override
  Widget build(BuildContext context) {
    bool notification = _preferences.getNotification();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              alignment: Alignment.bottomCenter,
              color: Theme.of(context).colorScheme.secondaryFixedDim,
              height: 100,
              child: Text(
                AppLocalizations.of(context)!.configuration.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    letterSpacing: 1),
              )),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: notification,
            title: Text(AppLocalizations.of(context)!.notification),
            onChanged: (value) {
              setState(() {
                value = !value;
              });
              _preferences.enableNotification(!value);
            },
          ),
          ListTile(
              leading: const Icon(Icons.file_copy_outlined),
              title: Text(
                  AppLocalizations.of(context)!.pioneerTitle), //'Sèvis Pyonye'
              onTap: () {
                Navigator.of(context).pop();
                Navigator.restorablePushNamed(
                    context, PyonyeServicesDataPicker.routeName);
              }),
          ExpansionTile(
            collapsedBackgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHigh,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            title: Text(
                AppLocalizations.of(context)!.language), //'Chwazi yon lang'
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
                    child: Text(AppLocalizations.of(context)!.fr), //"Fransè"
                  )),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Text(AppLocalizations.of(context)!.eng), //"Anglè"
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Text(AppLocalizations.of(context)!.es), //"Panyòl"
                ),
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(AppLocalizations.of(context)!.reportSrvce), //'Rapò'
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
