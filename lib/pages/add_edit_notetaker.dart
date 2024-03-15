import 'package:flutter/material.dart';
import 'package:notetaker/database/notetaker_database.dart';
import 'package:notetaker/models/notetaker.dart';
import 'package:notetaker/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({super.key, this.notetaker});
  final Notetaker? notetaker;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool _isImportant;
  late int _number;
  late String _title;
  late String _description;
  final _formKey = GlobalKey<FormState>();
  var _isUpdateForm = false;

  @override
  void initState() {
    super.initState();
    _isImportant = widget.notetaker?.isImportant ?? false;
    _number = widget.notetaker?.number ?? 0;
    _title = widget.notetaker?.title ?? '';
    _description = widget.notetaker?.description ?? '';
    _isUpdateForm = widget.notetaker != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isUpdateForm ? 'Edit Note' : 'Add Note',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildButtonSave(),
        ],
      ),
      body: Form(
          key: _formKey,
          child: NoteFormWidget(
              isImportant: _isImportant,
              number: _number,
              title: _title,
              description: _description,
              onChangeIsImportant: (value) {
                setState(() {
                  _isImportant = value;
                });
              },
              onChangeNumber: (value) {
                setState(() {
                  _number = value;
                });
              },
              onChangeTitle: (value) {
                setState(() {
                  _title = value;
                });
              },
              onChangeDescription: (value) {
                setState(() {
                  _description = value;
                });
              })),
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (isValid) {
              if (_isUpdateForm) {
                await _updateNote();
              } else {
                await _addNote();
              }
              Navigator.pop(context);
            }
          },
          child: const Text('Save')),
    );
  }

  Future<void> _addNote() async {
    final note = Notetaker(
        isImportant: _isImportant,
        number: _number,
        title: _title,
        description: _description,
        createdTime: DateTime.now());
    await NotetakerDatabase.instance.create(note);
  }

  Future<void> _updateNote() async {
    final updateNote = Notetaker(
        id: widget.notetaker?.id,
        isImportant: _isImportant,
        number: _number,
        title: _title,
        description: _description,
        createdTime: DateTime.now());
    await NotetakerDatabase.instance.updateNote(updateNote);
  }
}
