import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/menuOptionsScreen/menu_options_screen.dart';
import 'package:uniprocess_app/screens/subjectScreen/db_helper_subject.dart';

class SubjectScreen extends StatefulWidget {
  final String period;
  final String career;
  //static const String name = "Period_Screen";
  const SubjectScreen({super.key, required this.period, required this.career});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];
  final _fromkey = GlobalKey<FormState>();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data =
        await DBHelperSubject.getsingleDataCareer(widget.period, widget.career);
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }

  //final TextEditingController _periodController = TextEditingController();
  //final TextEditingController _careerController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showDialogSubject(int? id) async {
    bool isNewCareer = id == null;
    String dialogTitle = isNewCareer ? 'Nueva Carrera' : 'Actualizar Carrera';

    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _subjectController.text = existingData['subject'];
      _sectionController.text = existingData['section'];
      _semesterController.text = existingData['semester'];
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Center(
                child: Text(
                  dialogTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Form(
                key: _fromkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                          hintText: 'asignatura',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _sectionController,
                      decoration: InputDecoration(
                          hintText: 'seccion',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _semesterController,
                      decoration: InputDecoration(
                          hintText: 'semestre',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _subjectController.text = "";
                    _sectionController.text = "";
                    _semesterController.text = "";
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_fromkey.currentState!.validate()) {
                      // Save new period
                      if (id == null) {
                        await _addData();
                      }

                      if (id != null) {
                        await _updateData(id);
                      }

                      _subjectController.text = "";
                      _sectionController.text = "";
                      _semesterController.text = "";

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(id == null ? 'Nueva asignatura' : 'Actualizar'),
                ),
              ],
            ));
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar esta asinagtura?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(id);
            },
          ),
        ],
      ),
    );
  }

// Insert a new period to the database
  Future<void> _addData() async {
    await DBHelperSubject.createData(
        widget.period,
        widget.career,
        _subjectController.text,
        _sectionController.text,
        _semesterController.text);
    _refreshData();
  }

  // Update an existing period
  Future<void> _updateData(int id) async {
    await DBHelperSubject.updateData(
        id,
        widget.period,
        widget.career,
        _subjectController.text,
        _sectionController.text,
        _semesterController.text);
    _refreshData();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DBHelperSubject.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('eliminaste un periodo'),
    ));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(193, 234, 233, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 229, 227, 236),
        centerTitle: true,
        title: Text(
          "Asignatura",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.period} > ${widget.career}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _allData.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.lime[200],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return MenuOptionsScreen(
                                period: _allData[index]["period"],
                                career: _allData[index]["career"],
                                subject: _allData[index]["subject"],
                                section: _allData[index]["section"],
                                semester: _allData[index]["semester"],
                              );
                            }),
                          );
                        },
                        title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              _allData[index]['subject'],
                              style: const TextStyle(fontSize: 20),
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                _allData[index]['section'],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                _allData[index]['semester'],
                                style: const TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () =>
                                  _showDialogSubject(_allData[index]['id']),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _showDeleteConfirmationDialog(
                                  _allData[index]['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showDialogSubject(null),
      ),
    );
  }
}
