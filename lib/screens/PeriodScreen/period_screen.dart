import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/PeriodScreen/db_helper_period.dart';
import 'package:uniprocess_app/screens/careerScreen/career_screen.dart';

class PeriodScreen extends StatefulWidget {
  static const String name = "Period_Screen";
  const PeriodScreen({super.key});

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];
  final _fromkey = GlobalKey<FormState>();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperCareer.getAllData();
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

  final TextEditingController _periodController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showDialogPeriod(int? id) async {
    bool isNewPeriod = id == null;
    String dialogTitle = isNewPeriod ? 'Nuevo Periodo' : 'Actualizar Periodo';

    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _periodController.text = existingData['period'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
            child: Text(
          dialogTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        content: Form(
          key: _fromkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _periodController,
                decoration: InputDecoration(
                  hintText: 'Periodo',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0)),
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
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _periodController.text = '';
            },
          ),
          ElevatedButton(
            child: Text(id == null ? 'Nuevo Periodo' : 'Actualizar'),
            onPressed: () async {
              if (_fromkey.currentState!.validate()) {
                // Save new period
                if (id == null) {
                  await _addData();
                }

                if (id != null) {
                  await _updateData(id);
                }

                // Clear the text fields
                _periodController.text = '';

                // Close the dialog
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
            const Text('¿Estás seguro de que quieres eliminar este periodo?'),
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
    await DBHelperCareer.createData(_periodController.text);
    _refreshData();
  }

  // Update an existing period
  Future<void> _updateData(int id) async {
    await DBHelperCareer.updateData(id, _periodController.text);
    _refreshData();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DBHelperCareer.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('eliminaste un periodo'),
    ));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 242),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[600],
        centerTitle: true,
        title: const Text(
          "Periodo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
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
                        return CareerScreen(
                          period: _allData[index]["period"],
                        );
                      }),
                    );
                  },
                  title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['period'],
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
                            _showDialogPeriod(_allData[index]['id']),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showDialogPeriod(null),
      ),
    );
  }
}
