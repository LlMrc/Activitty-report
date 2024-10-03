import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/my_notifier.dart';
import 'package:report/src/screen/report_form.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../local/local.dart';
import '../model/report.dart';

class RepportScreen extends StatefulWidget {
  const RepportScreen({super.key});

  static const routeName = '/repport_screen';

  @override
  _RepportScreenState createState() => _RepportScreenState();
}

class _RepportScreenState extends State<RepportScreen> {
  void callBack() {
    setState(() {});
  }

  final SharedPreferencesSingleton _prefsInstance =
      SharedPreferencesSingleton();
  List<Repport> _repports = [];

  @override
  void initState() {
    _loadRepports();
    super.initState();
  }

  void _loadRepports() {
    final repports = _prefsInstance.getAllRepports();
    _repports = repports.where((item) => item.isSubmited == true).toList();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  Future<void> _deleteRepport(Repport repport) async {
    await _prefsInstance.deleteRepportByMonthAndYear(repport.submitAt);
    _loadRepports(); // Reload the list after deleting
  }

  Future<void> _updateCommentRepport(Repport repport) async {
    final updatedRepport = repport.copyWith(comment: commentController.text);
    await _prefsInstance.updateRepport(updatedRepport);
    _loadRepports(); // Reload the list after updating
  }

  @override
  Widget build(BuildContext context) {
    final isPyonye = Provider.of<PyonyeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 12),
            headerWidget(),
            const SizedBox(height: 12),
            _repports.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      SvgPicture.asset(
                          height: 200, width: 100, 'assets/svg/no_repport.svg'),
                      Text(AppLocalizations.of(context)!
                          .report) //Ou poko gen rapo
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _repports.length,
                      itemBuilder: (context, index) {
                        final repport = _repports[index];

                        return Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                        '${AppLocalizations.of(context)!.monthReport}: ${DateFormat.yMMM().format(repport.submitAt)}'), //Rapo pou mwa
                                    subtitle: Text(
                                        '${AppLocalizations.of(context)!.studentCount}: ${repport.student}'), //Kantite etidyan
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        ReportForm(
                                                            repport: repport,
                                                            rcontext: context,
                                                            callback: callBack,
                                                            isUpdate: true))),
                                        IconButton(
                                          icon: Icon(Icons.share,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () =>
                                              _shareRepport(repport),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isPyonye.isPyonye == true)
                                    additionalDetail(repport),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.comment,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ),
                                  if (repport.comment != null ||
                                      repport.comment!.isNotEmpty)
                                    InkWell(
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                alertDialog(repport));
                                      },
                                      splashColor: Colors.green,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '${repport.comment}'),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Positioned(
                                top: -4,
                                right: 6,
                                child: removeRepport(
                                  onPressed: () => _deleteRepport(repport),
                                ))
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => ReportForm(
                  rcontext: context, callback: callBack, isUpdate: false)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget headerWidget() {
    var name = SharedPreferencesSingleton().getName();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Card(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List Rapo',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (name != null)
                Text(name.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold)),
              Text('Komanse ${DateFormat.yMMM().format(DateTime.now())}')
            ],
          ),
        ],
      ),
    );
  }

  Widget removeRepport({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Text(
          'x'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget additionalDetail(Repport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                '${AppLocalizations.of(context)!.visit}: ${report.time}'), //Nouvèl vizit
            const SizedBox(width: 10),
            Text(
                '${AppLocalizations.of(context)!.publication}: ${report.time}'), //Piblikasyon
          ],
        ),
        Text('${AppLocalizations.of(context)!.time}: ${report.time}'), //lè
      ],
    );
  }

  alertDialog(Repport report) {
    return AlertDialog.adaptive(
      content: TextField(
        controller: commentController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: '${report.comment}'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () => _updateCommentRepport,
            child: Text(AppLocalizations.of(context)!.add))
      ],
    );
  }

  Future<void> _shareRepport(Repport r) async {
    String? name = SharedPreferencesSingleton().getName();
    await Share.share(
      '''

Mwen espere ke mesaj sa a jwenn ou byen!
Tanpri resevwa rapò a pou mwa  ${DateFormat.yMMMM().format(r.submitAt)}. Rapò sa a gen ladan detay sa yo:
- Non: $name
- Lè: ${r.time}
- Etidyan: ${r.student}
${r.publication != null ? '- Piblikasyon: ${r.publication}' : ''} 
${r.vizit != null ? '- Nouvèl vizit: ${r.vizit}' : ''} 

Mèsi pou atansyon ou sou sa!

      ''',
      subject: 'Soumèt rapo',
    );
  }
}



// I hope this message finds you well!
// Please find attached the report for the month of ${DateFormat.yMMMM().format(r.submitAt)}. This report includes the following details:
// - Non: $name
// - Le: ${r.time}
// - Etidyan: ${r.student}
// ${r.publication != null ? '- Piblikasyon: ${r.publication}' : ''} 
// ${r.vizit != null ? '- Nouvel vizit: ${r.vizit}' : ''} 

// Thank you for your attention to this matter!