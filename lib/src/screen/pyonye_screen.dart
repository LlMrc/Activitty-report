import 'package:flutter/material.dart';

import 'package:report/src/widget/single_month_picker.dart';

import '../widget/month_picker.dart';

class PyonyeServicesDataPicker extends StatefulWidget {
  const PyonyeServicesDataPicker({super.key});
  static const routeName = '/pyonye_screen';
  @override
  // ignore: library_private_types_in_public_api
  _PyonyeServicesDataPickerState createState() =>
      _PyonyeServicesDataPickerState();
}

class _PyonyeServicesDataPickerState extends State<PyonyeServicesDataPicker> {
 

  bool isSingleDate = false; // Toggle between single date and date range
  bool _isVisible = false;
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
       
          Container(height: 200,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/pyonye.jpg'))),
           child: Text('Chwazi Dat w\'ap komanse ✍',
           style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primaryContainer ,  fontWeight: FontWeight.w700,  shadows: [ BoxShadow(color: Colors.grey.shade700, offset: const Offset(1, -1))]),)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: isSingleDate
                  ? const Text('Sèvis Pyonye pou yon mwa!')
                  : const Text('Pou plizyè mwa!'),
              value: isSingleDate,
              onChanged: (bool value) {
                setState(() {
                  isSingleDate = value;

               
                });
              },
            ),
          ),

          const SizedBox(height: 24),
          isSingleDate ? const SingleMonthPicker() : const MonthRangePickerScreen(),
    
       
        ],
      ),
      bottomNavigationBar: _isVisible
          ? MaterialBanner(
              content: const Text('This is a Material Banner at the bottom!'),
              backgroundColor: Colors.green,
              actions: [
                TextButton(
                  onPressed: _hideBanner,
                  child: const Text('DISMISS'),
                ),
              ],
            )
          : null,
    );
  }

  void _hideBanner() {
    setState(() {
      _isVisible = false;
    });
  }





}
