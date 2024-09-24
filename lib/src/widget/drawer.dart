import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
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
        
           ListTile(leading: const Icon(Icons.note_add), title: const Text('Pran sevis Pyonye 📝'),
          onTap:(){
                 Navigator.restorablePushNamed(
          context,
          PyonyeServicesDataPicker.routeName
         
        );
          }),
             ExpansionTile(
              collapsedBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              
              title: const Text('Chwazi yon lang'),
              children: [
                 InkWell(
                  onTap: (){
                       Navigator.of(context).pop();
                  },
                  highlightColor: Colors.black45,
                   child: Container(
                                  
                                   padding: const EdgeInsets.all(20),
                                   width: double.infinity,
                                   child: const Text("Franse"),
                                 )),
          
                InkWell(
                       onTap: () {
                        Navigator.of(context).pop();
                       },
                  child: Container(               
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text("Angle"),
                                )),
              InkWell(onTap: () {
                         Navigator.of(context).pop();
                     },
                child: Container(                         
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text("Panyol"),
                ),
              )
              ],
             )
        ],
      ),
    );
  }
}
