import 'package:flutter/material.dart';
import 'package:report/src/widget/single_month_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/month_picker.dart';

class PyonyeServicesDataPicker extends StatefulWidget {
  const PyonyeServicesDataPicker({super.key});
  static const routeName = '/pyonye_screen';

  @override
  _PyonyeServicesDataPickerState createState() =>
      _PyonyeServicesDataPickerState();
}

class _PyonyeServicesDataPickerState extends State<PyonyeServicesDataPicker> {
  bool isSingleDate = false; // Toggle between single date and date range

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/pyonye.jpg'))),
              child: Text(
                AppLocalizations.of(context)!
                    .pioneerTitle, //Chwazi Dat w\'ap komanse ✍
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      const BoxShadow(
                          color: Colors.black, offset: Offset(1, -1))
                    ]),
              )),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: isSingleDate
                  ? Text(AppLocalizations.of(context)!
                      .pioneerforOneMonth) //Sèvis Pyonye pou yon mwa!
                  : Text(AppLocalizations.of(context)!
                      .pioneerforTwoMonth), //Pou plizyè mwa!
              value: isSingleDate,
              onChanged: (bool value) {
                setState(() {
                  isSingleDate = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          isSingleDate
              ? const SingleMonthPicker()
              : const MonthRangePickerScreen(),
        ],
      ),
    );
  }
}
