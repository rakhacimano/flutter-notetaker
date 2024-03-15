import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notetaker/database/notetaker_database.dart';
import 'package:notetaker/models/notetaker.dart';
import 'package:notetaker/pages/detail_page.dart';
import 'package:notetaker/widgets/notetaker_card_widget.dart';
import 'package:notetaker/pages/add_edit_notetaker.dart';

class NotetakerPage extends StatefulWidget {
  const NotetakerPage({super.key});

  @override
  State<NotetakerPage> createState() => _NotetakerPageState();
}

class _NotetakerPageState extends State<NotetakerPage> {
  late List<Notetaker> _notes;
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _notes = await NotetakerDatabase.instance.getAllNotes();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _refreshNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notetaker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              // final notataker = Notetaker(
              // isImportant: false,
              // number: 1,
              // title: 'Title Test',
              // description: 'Description Test',
              // createdTime: DateTime.now());
              // await NotetakerDatabase.instance.create(notataker);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddEditNotePage()));
              _refreshNotes();
            }),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _notes.isEmpty
                ? const Text('Notes kosong')
                : MasonryGridView.count(
                    crossAxisCount: 2,
                    itemCount: _notes.length,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      final notetaker = _notes[index];
                      return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(id: notetaker.id!)));
                            _refreshNotes();
                          },
                          child: NotatakerCardWidget(
                              notetaker: notetaker, index: index));
                    }));
  }
}
