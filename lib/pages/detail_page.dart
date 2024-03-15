import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/database/notetaker_database.dart';
import 'package:notetaker/models/notetaker.dart';
import 'package:notetaker/pages/add_edit_notetaker.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Notetaker _notetaker;
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _notetaker = await NotetakerDatabase.instance.getNoteById(widget.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [_buildEditButton(), _buildDeleteButton()],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  _notetaker.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(DateFormat.yMMMd().format(_notetaker.createdTime)),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _notetaker.description ?? '',
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditNotePage(
                        notetaker: _notetaker,
                      )));
          _refreshNotes();
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Widget _buildDeleteButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await NotetakerDatabase.instance.deleteNoteById(widget.id);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete));
  }
}
