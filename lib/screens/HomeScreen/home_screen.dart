import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uniprocess_app/screens/HomeScreen/db_helper_note.dart';
import 'package:uniprocess_app/screens/HomeScreen/model_note.dart';
import 'package:uniprocess_app/screens/screen.dart';
import 'package:uniprocess_app/screens/userScreen/register_screen.dart';
import 'package:uniprocess_app/widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  static const String name = "Home_Screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> _showAddNoteDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nota'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _fromkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: null,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: descController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descripción',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_fromkey.currentState!.validate()) {
                  final title = titleController.text;
                  final description = descController.text;
                  _addNote(title, description);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNote(String title, String description) async {
    final note = NoteModel(
      title: title,
      desc: description,
      dateandtime: DateFormat('yMd').add_jm().format(DateTime.now()).toString(),
    );

    await dbHelperNote!.insert(note);
    setState(() {
      dataList = dbHelperNote!.getDataList();
    });
  }

  Future<void> _showUpdateNoteDialog(int noteId, String currentTitle,
      String currentDesc, String currentDT) async {
    final titleController = TextEditingController(text: currentTitle);
    final descController = TextEditingController(text: currentDesc);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualizar Nota'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _fromkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: null,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: descController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descripción',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_fromkey.currentState!.validate()) {
                  final updatedTitle = titleController.text;
                  final updatedDesc = descController.text;
                  _updateNote(noteId, updatedTitle, updatedDesc);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateNote(
      int noteId, String updatedTitle, String updatedDesc) async {
    final updatedNote = NoteModel(
      id: noteId,
      title: updatedTitle,
      desc: updatedDesc,
      dateandtime: DateFormat('yMd').add_jm().format(DateTime.now()).toString(),
    );

    await dbHelperNote!.update(updatedNote);
    setState(() {
      dataList = dbHelperNote!.getDataList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(233, 255, 255, 255),
      //drawer: const SideMenu(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 227, 229, 234),
        title: const Text(
          "UNIPROCESS",
          style: TextStyle(
            fontSize: 22.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              iconSize: 30.0,
              onPressed: () {},
              icon: const Icon(Icons.account_circle),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: const Text(
              "Bienvenido Ing. Alessandro Hidalgo",
              style: TextStyle(
                color: Color.fromARGB(255, 51, 50, 53),
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          /*Container(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(214, 161, 184, 223),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xC69864C8),
                        blurRadius: 0.5,
                      )
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 100, right: 10),
                      child: Text(
                        "Esta aplicacion es una herramienta tecnologica que te ayudara automatizar los procesos academicos y administrativo de tu gestion universitaria.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 0,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.transparent,
                        BlendMode.color), // Cambia el color aquí
                    child: Image.asset(
                      "assets/imagen/img1.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent[50])),
                onPressed: () {
                  context.pushNamed(PeriodScreen.name);
                },
                icon: const Icon(Icons.app_registration_outlined),
                label: const Text("Lista"),
              ),
              const SizedBox(
                width: 10,
              ),
              FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent[50])),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ReportScreen();
                    }),
                  );
                },
                icon: const Icon(Icons.report),
                label: const Text("Reporte"),
              ),
              const SizedBox(
                width: 10,
              ),
              FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent[500])),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const ScheduleScreen();
                    }),
                  );
                },
                icon: const Icon(Icons.schedule),
                label: const Text("Horario"),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Mis Notas",
              style: TextStyle(
                color: Color.fromARGB(255, 51, 50, 53),
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Agrega una nota",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(132, 202, 194, 194),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int noteId = snapshot.data![index].id!.toInt();
                      String noteTitle = snapshot.data![index].title.toString();
                      String noteDesc = snapshot.data![index].desc.toString();
                      String noteDT =
                          snapshot.data![index].dateandtime.toString();
                      return Dismissible(
                        key: ValueKey<int>(noteId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.redAccent,
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Nota'),
                                content: const Text(
                                  '¿Estás seguro de eliminar esta nota?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelperNote!.delete(noteId);
                            dataList = dbHelperNote!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromARGB(214, 161, 184, 223),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(245, 245, 245, 245),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    noteTitle,
                                    style: const TextStyle(fontSize: 19),
                                  ),
                                ),
                                subtitle: Text(
                                  noteDesc,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 0.8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      noteDT,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showUpdateNoteDialog(
                                          noteId,
                                          noteTitle,
                                          noteDesc,
                                          noteDT,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.edit_note_outlined,
                                        size: 30,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
