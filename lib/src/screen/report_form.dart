import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/report.dart';

// ignore: must_be_immutable
class ReportForm extends StatefulWidget {
  ReportForm(
      {super.key,
      this.repport,
      required this.isUpdate,
      required this.rcontext,
      required this.callback});
  final BuildContext rcontext;
  Repport? repport;
  final bool isUpdate;
  final VoidCallback callback;

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final SharedPreferencesSingleton _prefsInstance =
      SharedPreferencesSingleton();

  final pub = ValueNotifier<int>(0);
  final vizit = ValueNotifier<int>(0);
  final student = ValueNotifier<int>(0);
  final time = ValueNotifier<int>(0);
  String? comment;
  String? name;

  Future<void> _updateCommentRepport(Repport repport) async {
    final updatedRepport = repport.copyWith(
      comment: '$comment',
      name: '$name',
      publication: pub.value,
      vizit: vizit.value,
      student: student.value,
    );
    String? n = _prefsInstance.getName();
    n == null
        ? _prefsInstance.saveName(name ?? '')
        : _prefsInstance.updateName(name ?? '');
    await _prefsInstance.updateRepport(updatedRepport);
  }

  Future<void> _saveRepport() async {
    final repport = Repport(
        name: '$name',
        student: student.value,
        isPyonye: false,
        comment: '$comment',
        time: '${time.value}',
        submitAt: DateTime.now());
    await _prefsInstance.saveRepport(repport);
    String? n = _prefsInstance.getName();
    n == null
        ? _prefsInstance.saveName(name ?? '')
        : _prefsInstance.updateName(name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
                onChanged: (value) => setState(
                      () => name = value,
                    ),
                decoration: const InputDecoration(border: InputBorder.none)),
          ),
          counterWidget(context,
              text: AppLocalizations.of(context)!.time, //'Lè',
              increment: () => time.value + 1,
              decrement: () => time.value > 0 ? time.value - 1 : null,
              value: pub),
          counterWidget(context,
              text: AppLocalizations.of(context)!.publication, //'Piblikasyon',
              increment: () => pub.value + 1,
              decrement: () => pub.value > 0 ? pub.value - 1 : pub.value,
              value: pub),
          counterWidget(context,
              text: AppLocalizations.of(context)!.visit, //'nouvèl vizit',
              increment: () => vizit.value + 1,
              decrement: () => vizit.value > 0 ? vizit.value - 1 : null,
              value: vizit),
          counterWidget(context,
              text: AppLocalizations.of(context)!.student, //'Etidyan',
              increment: () => student.value + 1,
              decrement: () => student.value > 0 ? student.value - 1 : null,
              value: student),
          const SizedBox(height: 10),
          TextFormField(
              maxLines: 3,
              onChanged: (value) => setState(
                    () => comment = value,
                  ),
              decoration: InputDecoration(
                  label:
                      Text(AppLocalizations.of(context)!.comment), //'Kòmantè'
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
          const SizedBox(height: 10),
          ElevatedButton.icon(
              onPressed: () async {
                if (widget.isUpdate && widget.repport != null) {
                  await _updateCommentRepport(widget.repport!);
                } else {
                  await _saveRepport();
                }

                if (widget.rcontext.mounted) {
                  Navigator.of(widget.rcontext).pop();
                }
              },
              label:
                  Text(AppLocalizations.of(context)!.saveButton)) //'Anregistre'
        ],
      ),
    );
  }

  Widget counterWidget(BuildContext context,
      {required String text,
      required ValueListenable<dynamic> value,
      required VoidCallback increment,
      required VoidCallback decrement}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: decrement,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.remove),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder(
                  valueListenable: value,
                  builder: (context, value, _) => Text('$value')),
            ),
            GestureDetector(
              onTap: increment,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add),
                  )),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
        )
      ],
    );
  }
}
