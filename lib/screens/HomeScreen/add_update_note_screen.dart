import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniprocess_app/screens/HomeScreen/db_helper_note.dart';
import 'package:uniprocess_app/screens/HomeScreen/home_screen.dart';
import 'package:uniprocess_app/screens/HomeScreen/model_note.dart';

// ignore: must_be_immutable
class AddUpdateTask extends StatefulWidget {
  int? todoid;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  AddUpdateTask(
      {super.key,
      this.todoid,
      this.todoTitle,
      this.todoDesc,
      this.todoDT,
      this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;
  final _fromkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "update task";
    } else {
      appTitle = "add task";
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
                            return "enter some text";
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
                            return "enter some text";
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
                              dbHelper!.update(TodoModel(
                                  id: widget.todoid,
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: widget.todoDT));
                            } else {
                              dbHelper!.insert(TodoModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: DateFormat("yMd")
                                      .add_jm()
                                      .format(DateTime.now())
                                      .toString()));
                            }
                            Navigator.push(
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
                          width: 120,
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]),
                          child: const Text(
                            "agregar",
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
                            "limpiar",
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
