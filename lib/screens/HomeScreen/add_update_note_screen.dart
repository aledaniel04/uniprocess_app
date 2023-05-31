import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniprocess_app/screens/HomeScreen/db_helper_note.dart';
import 'package:uniprocess_app/screens/HomeScreen/home_screen.dart';
import 'package:uniprocess_app/screens/HomeScreen/model_note.dart';

// ignore: must_be_immutable
class AddUpdateNote extends StatefulWidget {
  int? noteid;
  String? noteTitle;
  String? noteDesc;
  String? noteDT;
  bool? update;

  AddUpdateNote(
      {super.key,
      this.noteid,
      this.noteTitle,
      this.noteDesc,
      this.noteDT,
      this.update});

  @override
  State<AddUpdateNote> createState() => _AddUpdateNoteState();
}

class _AddUpdateNoteState extends State<AddUpdateNote> {
  DBHelperNote? dbHelperNote;
  late Future<List<NoteModel>> dataList;
  final _fromkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelperNote = DBHelperNote();
    loadData();
  }

  loadData() async {
    dataList = dbHelperNote!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.noteTitle);
    final descController = TextEditingController(text: widget.noteDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Actualizar nota";
    } else {
      appTitle = "Agregar nota";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "titulo de la nota"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "este campo es requerido";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: descController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "escribe una nota aqui"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "este campo es requerido";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green,
                      child: InkWell(
                        onTap: () {
                          if (_fromkey.currentState!.validate()) {
                            if (widget.update == true) {
                              dbHelperNote!.update(NoteModel(
                                  id: widget.noteid,
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: widget.noteDT));
                            } else {
                              dbHelperNote!.insert(NoteModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: DateFormat("yMd")
                                      .add_jm()
                                      .format(DateTime.now())
                                      .toString()));
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                            titleController.clear();
                            descController.clear();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 55,
                          width: 130,
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]),
                          child: const Text(
                            "Agregar",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red[400],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(),
                          child: const Text(
                            "Borrar",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
