import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/careerScreen/db_helper_caeer.dart';
import 'package:uniprocess_app/screens/subjectScreen/subject_screen.dart';

class CareerScreen extends StatefulWidget {
  final String period;
  static const String name = "Period_Screen";
  const CareerScreen({super.key, required this.period});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];
  final _fromkey = GlobalKey<FormState>();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperNewCareer.getsingleDataPeriod(widget.period);
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
  final TextEditingController _careerController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showDialogCareer(int? id) async {
    bool isNewCareer = id == null;
    String dialogTitle = isNewCareer ? 'Nueva Carrera' : 'Actualizar Carrera';

    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _careerController.text = existingData['career'];
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
            children: [
              TextFormField(
                controller: _careerController,
                decoration: InputDecoration(
                    hintText: 'Carrera',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0))),
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
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _careerController.text = '';
            },
          ),
          ElevatedButton(
            child: Text(id == null ? 'Nueva Carrera' : 'Actualizar'),
            onPressed: () async {
              if (_fromkey.currentState!.validate()) {
                // Save new career
                if (id == null) {
                  await _addData();
                }

                // Update existing career
                if (id != null) {
                  await _updateData(id);
                }

                _careerController.text = '';

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta carrera?'),
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
    await DBHelperNewCareer.createData(_careerController.text, widget.period);
    _refreshData();
  }

  // Update an existing period
  Future<void> _updateData(int id) async {
    await DBHelperNewCareer.updateData(
        id, _careerController.text, widget.period);
    _refreshData();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DBHelperNewCareer.deleteData(id);
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
          "Carreras",
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
                widget.period,
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
                              return SubjectScreen(
                                period: _allData[index]["period"],
                                career: _allData[index]["career"],
                              );
                            }),
                          );
                        },
                        title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              _allData[index]['career'],
                              style: const TextStyle(fontSize: 20),
                            )),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () =>
                                  _showDialogCareer(_allData[index]['id']),
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
        onPressed: () => _showDialogCareer(null),
      ),
    );
  }
}
