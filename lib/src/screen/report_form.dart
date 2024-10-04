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
    await _prefsInstance.updateRepport(updatedRepport);
    if (name != null) {
      _prefsInstance.saveName(name ?? '');
    }
  }

  Future<void> _saveRepport() async {
    var r = _prefsInstance.getAllRepports();
    final repport = Repport(
        name: '$name',
        student: student.value,
        isPyonye: false,
        comment: comment,
        time: '${time.value}',
        publication: pub.value,
        vizit: vizit.value,
        isSubmited: true,
        submitAt: DateTime.now());
    if (r.isNotEmpty) {
      var date = r.last.submitAt;

      if (date.month == repport.submitAt.month) {
        await _prefsInstance.updateRepport(repport);
      }
    } else {
      await _prefsInstance.saveRepport(repport);
    }

     if (name != null) {
      _prefsInstance.saveName(name ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onChanged: (value) => setState(
                    () => name = value,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.person),
                  ),
                )),
            counterWidget(context,
                text: AppLocalizations.of(context)!.time, //'Lè',
        
                val: time),
            counterWidget(context,
                text: AppLocalizations.of(context)!.publication, //'Piblikasyon',
        
                val: pub),
            counterWidget(context,
                text: AppLocalizations.of(context)!.visit, //'nouvèl vizit',
        
                val: vizit),
            counterWidget(context,
                text: AppLocalizations.of(context)!.student, //'Etidyan',
                val: student),
            const SizedBox(height: 30),
            TextFormField(
                maxLines: 3,
                onChanged: (value) => setState(() => comment = value),
                decoration: InputDecoration(
                    label:
                        Text(AppLocalizations.of(context)!.comment), //'Kòmantè'
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))))),
            const SizedBox(height: 30),
        
            GestureDetector(
              onTap: () async {
                if (widget.isUpdate && widget.repport != null) {
                  await _updateCommentRepport(widget.repport!);
                } else {
                  await _saveRepport();
                 
                }
                if (widget.rcontext.mounted) {
                  Navigator.of(widget.rcontext).pop();
                }
        
                widget.callback();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary),
                child: Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.saveButton.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            )
            //'Anregistre'
          ],
        ),
      ),
    );
  }

  Widget counterWidget(
    BuildContext context, {
    required String text,
    required ValueNotifier<int>
        val, // Ensure the ValueListenable is of type int
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Text(text),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () => val.value > 0
                ? val.value = val.value - 1 // Decrement properly

                : val.value, // Only decrement if value is greater than 0
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.remove),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<int>(
              valueListenable: val,
              builder: (context, value, _) => Text('$value'),
            ),
          ),
          GestureDetector(
            onTap: () => val.value = val.value + 1, // Increment properly
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
