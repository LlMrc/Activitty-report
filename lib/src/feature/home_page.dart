import 'package:flutter/material.dart';
import 'package:report/local.dart';


import '../settings/settings_view.dart';
import '../shape/custom_shape.dart';
import '../model/sample_item.dart';
import 'datails.dart';

/// Displays a list of SampleItems.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.items = const [
      SampleItem(1, 'assets/images/user.png', 'Etidyan'),//<a href="https://www.flaticon.com/free-icons/add" title="add icons">Add icons created by Freepik - Flaticon</a>
      SampleItem(2, 'assets/images/note.png', 'Pran Not'),  //<a href="https://www.flaticon.com/free-icons/add" title="add icons">Add icons created by Pixel perfect - Flaticon</a>
      SampleItem(3, 'assets/images/calendar.png', 'Ajanda')],//<a href="https://www.flaticon.com/free-icons/agenda" title="agenda icons">Agenda icons created by Freepik - Flaticon</a>
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    final _studentPreferences = StudentPreferences();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
   
        body: Column(
          children: [
      const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// background image
                      Container(
              
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.jpeg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
                      ),
                      CustomPaint(
              painter: CardPaint(),
              size: const Size(600, 200),
                      ),
                       Positioned(
               top: 0,
               right: 0,
                         child: IconButton(
                                   icon: const Icon(Icons.settings),
                                   onPressed: () {
                                             // Navigate to the settings page. If the user leaves and returns
                                             // to the app after it has been killed while running in the
                                             // background, the navigation stack is restored.
                                             Navigator.restorablePushNamed(context, SettingsView.routeName);
                                   },
                                 ),
                       ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.items.map((item)=>buildItem(item, context)).toList()
          ),
          const SizedBox(height: 10),

          FutureBuilder(
            future: _studentPreferences.getAllStudents(),
          builder: (context, snapShot){
           final students = snapShot.data;
           if(snapShot.connectionState == ConnectionState.waiting){
             return const Center(child: CircularProgressIndicator());
                    
                    
          }
          if(students == null || students.isEmpty){
           return  SizedBox(
         
            child:
           Column(children:  List.generate(3, (index) =>ListTile(
          leading: const CircleAvatar(),
           title: Container( 
            width: 70,
            height: 18, color:Colors.grey[300]),
           subtitle: Container(
           width: 50,
           height:20, color:Colors.grey[200]),
           )) )
          );
          
          }
          return Expanded(
            child: ListView.builder(
              itemCount: students.length,
             itemBuilder:(context, index)=>Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(10)),
               child: ListTile(
                 title: Text(students[index].name),
                 subtitle: Text(students[index].phoneNumber ?? ''),
                 trailing: IconButton(
                   icon: const Icon(Icons.delete),
                   onPressed: () async {
                     await _studentPreferences.removeStudent(students[index].name);
                     setState(() {
                       students.removeAt(index);
                     });
                   },
                 ),
                ),
             ) ,
            
            ),
          );
            })
          ],
        ),
      ),
    );
  }

  Widget buildItem(SampleItem item, BuildContext context) {
           return   InkWell(
            key:Key(item.id.toString()) ,
                          onTap: () {
                          // Navigate to the details page. If the user leaves and returns to
                          // the app after it has been killed while running in the
                          // background, the navigation stack is restored.
                          Navigator.restorablePushNamed(
                            context,
                            SampleItemDetailsView.routeName,
                          );
                        },
                        child: Container(
                          
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(10),
                                                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            color:Colors.white,
                   boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],  
                            borderRadius: BorderRadius.circular(10),
                          
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                width: 50,
                              height: 50,
                              item.imagePath),
                              const SizedBox(height: 8),
                              Text(item.title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                            ],
                          ),
                                        
                        
                        ),
                      );
         
  }
}
  // appBar: AppBar(
      //   title: const Text('Sample Items'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.settings),
      //       onPressed: () {
      //         // Navigate to the settings page. If the user leaves and returns
      //         // to the app after it has been killed while running in the
      //         // background, the navigation stack is restored.
      //         Navigator.restorablePushNamed(context, SettingsView.routeName);
      //       },
      //     ),
      //   ],
      // ),