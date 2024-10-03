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
              title:
                  Text(AppLocalizations.of(context)!.pioneer), //'Sèvis Pyonye'
              onTap: () {
                Navigator.of(context).pop();
                Navigator.restorablePushNamed(
                    context, PyonyeServicesDataPicker.routeName);
              }),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(AppLocalizations.of(context)!.reportSrvce), //'Rapò'
            onTap: () {
              Navigator.of(context).pop();
              Navigator.restorablePushNamed(context, RepportScreen.routeName);
            },
          ),
          ListTile(
              leading: const Icon(Icons.share),
              title:
                  Text(AppLocalizations.of(context)!.share), //'Pataje app la'
              onTap: () {
                Navigator.of(context).pop();
                Navigator.restorablePushNamed(
                    context, PyonyeServicesDataPicker.routeName);
              }),
        ],
      ),
    );
  }
}
