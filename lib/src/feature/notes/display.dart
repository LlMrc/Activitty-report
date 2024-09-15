import 'package:flutter/material.dart';
import 'package:report/src/model/note.dart';

import '../../local/local.dart';

class DisplayNote extends StatefulWidget {
  const DisplayNote({super.key, required this.note, required this.onPressed});
  final Note note;
  final VoidCallback onPressed;

  @override
  State<DisplayNote> createState() => _DisplayNoteState();
}

class _DisplayNoteState extends State<DisplayNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final noteManager = SharedPreferencesSingleton();

  void _updatedNote() async {
    // Updating the note
    final updatedNote = Note(
      color: widget.note.color,
      id: widget.note.id, // Use the same ID to update
      title: widget.note.title,
      content: _descController.text,
      createdAt: widget.note.createdAt,
    );

    await noteManager.saveOrUpdateNote(updatedNote);
  }

  void reloadState() {
    setState(() {
      debugPrint('RELOAD');
    });
  }

  @override
  void initState() {
    _descController.text = widget.note.content;
    _titleController.text = widget.note.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: TextFormField(
                        expands: true,
                        controller: _descController,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: null,
                        minLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
              decoration: const BoxDecoration(
                  border: BorderDirectional(top: BorderSide(width: 0.5))),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Update note'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        _updatedNote();
                        if (mounted) {
                          widget.onPressed();
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ),
                ],
              )),
        ));
  }
}
