import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import '../../local/local.dart';
import '../../model/note.dart';

class AddNote extends StatefulWidget {
  const AddNote(
      {super.key, required this.noteContext, required this.onPressed});
  final BuildContext noteContext;
  final VoidCallback onPressed;
  @override
  State<AddNote> createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {
  final noteManager = SharedPreferencesSingleton();
  // Create a new note with a unique ID
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Color noteColor = const Color(0xffeee8e8);
  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      const uuid = Uuid();
      final note = Note(
        id: uuid.v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        color: noteColor,
        createdAt: DateTime.now(),
      );

      await noteManager.saveOrUpdateNote(note);
      // Clear the text fields after saving
      _titleController.clear();
      _contentController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully!')),
        );
      }
    }
    widget.onPressed();
  }

  List<Color> color = const [
    Color.fromARGB(255, 113, 141, 191),
    Color.fromARGB(255, 223, 121, 121),
    Color.fromARGB(255, 89, 190, 162),
    Color.fromARGB(255, 210, 132, 217),
    Color.fromARGB(255, 65, 184, 240),
    Color.fromARGB(255, 142, 217, 132),
    Color(0xffC8C2BC),
    Color.fromARGB(255, 221, 141, 88),
    Color.fromARGB(255, 205, 197, 92),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 25),
            labelText('Title'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    isDense: true,
                
                    prefixIcon: Icon(Icons.edit, color: Colors.grey[400]),
                    hintText: 'Title...',
                  )),
            ),
            const SizedBox(height: 28),
            labelText('Content'),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                  expands: true,
                  controller: _contentController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hoverColor: Colors.indigo),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(height: 50, child: _stickyNoteColor()),
            const SizedBox(height: 30),
            MaterialButton(
                onPressed: () {
                  _saveNote();
                  Navigator.of(widget.noteContext).pop();
                },
                elevation: 4,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Add note',
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  Widget labelText(String txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          textAlign: TextAlign.start,
          txt,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  bool isSelected = false;
  int? selectedColorIndex; // State variable to track the selected color index

  _stickyNoteColor() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: color.length,
      itemBuilder: (context, index) {
        final boxColor = color[index];
        final isSelected =
            index == selectedColorIndex; // Check if this color is selected

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                noteColor = boxColor;
                selectedColorIndex = index; // Update the selected index
              });
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: boxColor,
              ),
              child: AnimatedOpacity(
                opacity:
                    isSelected ? 1.0 : 0.0, // Show the check icon if selected
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
