import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:report/src/feature/notes/display.dart';
import 'package:report/src/feature/notes/sticky_note_ui.dart';
import '../../local/local.dart';
import 'add_note.dart';


class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});
  static const routeName = '/note_screen';
  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  bool isvisible = false;
  final noteRepository = SharedPreferencesSingleton();
  @override
  Widget build(BuildContext context) {
    // Retrieve notes.
    final notes = noteRepository.getNotes();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 145,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  image: SilverBar
                      .getColorItem(), //AssetImage('assets/appBar.jpg'),
                  fit: BoxFit.cover,
                ),
                title: Text('Sticky notes',
                    style: TextStyle(color: Colors.grey[400])),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child:notes.isNotEmpty? Column(
                children: [
                  Visibility(visible: isvisible, child: suggestList()),
                  GridView.count(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: isPortrait ? 2 : 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    children: notes.map((note) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                child: StickyNote(
                                  color: note.color,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 6),
                                      Text(
                                        note.title.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          overflow: TextOverflow.clip,
                                       
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          note.content,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                     
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DisplayNote(
                                              note: note,
                                              onPressed: () => setState(() {}))));
                                },
                              ),
                            ),
                            Positioned(
                                top: -5,
                                right: -10,
                                child: IconButton(
                                    onPressed: () async {
                                      await noteRepository
                                          .deleteNoteById(note.id);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.push_pin_sharp,
                                      color: Colors.cyan,
                                      shadows: [
                                        BoxShadow(
                                            offset: Offset(-1, 1),
                                            blurRadius: 2,
                                            spreadRadius: 1.5)
                                      ],
                                    )))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ):   Column(
                  
                      children: [
                        const SizedBox(height: 100),
                        SvgPicture.asset(
                            height: 200,
                            width: 100,
                            'assets/svg/no_note.svg'),
                     
                      ],
                    )
                ,
            ),
          ],
        ),
        //--------}----------- floatingActionButton--------------------------------

        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            tooltip: 'Add note',
            elevation: 4,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.scrim,
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SizedBox(
                        height: 410,
                        child: AddNote(
                            noteContext: context,
                            onPressed: () => setState(() {})),
                      )));
            }),
      ),
    );
  }

  Widget suggestList() {
    return Container(
      height: 600,
      width: 400,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, indext) {
            return const ListTile(
              title: Text("search text"),
            );
          }),
    );
  }
}

////////////////////////////    NOTES DETAILS ////////////////////////////////////////////////
class SilverBar {
  static List sliverAppBar = const [
    AssetImage('assets/kong1.jpg'),
    AssetImage('assets/kong2.jpg'),
    AssetImage('assets/kong3.jpg'),
    AssetImage('assets/kong4.jpg'),
    AssetImage('assets/kong6.png'),
    AssetImage('assets/kong7.jpg'),
    AssetImage('assets/kong5.jpg'),
    AssetImage('assets/kong8.jpg'),
    AssetImage('assets/kong9.jpg')
  ];
  static AssetImage getColorItem() => (sliverAppBar.toList()..shuffle()).first;
}
