import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/studentsList/db_helper_students_list.dart';

class StudentsListScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  //static const String name = "Period_Screen";
  const StudentsListScreen(
      {super.key,
      required this.period,
      required this.career,
      required this.subject,
      required this.section,
      required this.semester});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperStudentsList.getsingleDataStudenstList(
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester);
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showBottomSheet(int? id) async {
    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nameController.text = existingData['name'];
      _lastnameController.text = existingData['lastname'];
      _cedulaController.text = existingData['cedula'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
            child: Text(
          'estudiante',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nombre'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(hintText: 'Apellido'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(hintText: 'Cedula'),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _nameController.text = '';
              _lastnameController.text = "";
              _cedulaController.text = "";
            },
          ),
          ElevatedButton(
            child: Text(id == null ? 'Agregar Estudiante' : 'Actualizar'),
            onPressed: () async {
              // Save new period
              if (id == null) {
                await _addData();
              }

              if (id != null) {
                await _updateData(id);
              }

              // Clear the text fields
              _nameController.text = '';
              _lastnameController.text = "";
              _cedulaController.text = "";

              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

// Insert a new period to the database
  Future<void> _addData() async {
    await DBHelperStudentsList.createData(
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester,
        _nameController.text,
        _lastnameController.text,
        _cedulaController.text);
    _refreshData();
  }

  // Update an existing period
  Future<void> _updateData(int id) async {
    await DBHelperStudentsList.updateData(
        id,
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester,
        _nameController.text,
        _lastnameController.text,
        _cedulaController.text);
    _refreshData();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DBHelperStudentsList.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('eliminaste un estudiantes'),
    ));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 242),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[600],
        toolbarHeight: 150,
        centerTitle: true,
        title: Text(
          """${widget.period} - ${widget.career} 
          ${widget.subject} -${widget.section} 
          ${widget.semester} 
            lista de Estudiantes
          """,
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
                  onTap: () {},
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _allData[index]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          _allData[index]["lastname"],
                          style: const TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]["cedula"],
                      style: const TextStyle(fontSize: 20),
                    ),
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
                            _showBottomSheet(_allData[index]['id']),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _deleteItem(_allData[index]['id']),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showBottomSheet(null),
      ),
    );
  }
}
