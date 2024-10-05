import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/screen/repport_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../screen/history.dart';
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
              height: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  image: const DecorationImage(
                      // colorFilter:
                      //     ColorFilter.mode(Colors.green, BlendMode.color),
                      fit: BoxFit.cover,
                      image: AssetImage('assets/kong1.jpg'))),
              child: Text(
                AppLocalizations.of(context)!.configuration.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w700,
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
              leading: const Icon(Icons.drive_file_rename_outline_outlined),
              title:
                  Text(AppLocalizations.of(context)!.pioneer), //'Sèvis Pyonye'
              onTap: () {
                Navigator.of(context).pop();
                Navigator.restorablePushNamed(
                    context, PyonyeServicesDataPicker.routeName);
              }),
          ListTile(
            leading: const Icon(Icons.file_copy_outlined),
            title: Text(AppLocalizations.of(context)!.reportSrvce), //'Rapò'
            onTap: () {
              Navigator.of(context).pop();
              Navigator.restorablePushNamed(context, RepportScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(AppLocalizations.of(context)!.history), //'history'
            onTap: () {
              Navigator.of(context).pop();
              Navigator.restorablePushNamed(context, MyActivity.routeName);
            },
          ),
          ListTile(
              leading: const Icon(Icons.share),
              trailing: const Icon(Icons.android_sharp, color: Colors.green),
              title:
                  Text(AppLocalizations.of(context)!.share), //'Pataje app la'
              onTap: () {
                Navigator.of(context).pop();
                Share.share(
                    'Check out this app on Playstore  https://play.google.com/store/apps/details?id=com.codegroove.taskflow');
              }),
        ],
      ),
    );
  }
}
