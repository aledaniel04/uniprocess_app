import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/qualificationScreen/db_helper_qualification.dart';
import 'package:intl/intl.dart';

class AddQualificationScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  final int idstudent;
  final String name;
  final String lastname;
  final String cedula;
  //static const String name = "Period_Screen";
  const AddQualificationScreen({
    super.key,
    required this.period,
    required this.career,
    required this.subject,
    required this.section,
    required this.semester,
    required this.idstudent,
    required this.name,
    required this.lastname,
    required this.cedula,
  });

  @override
  State<AddQualificationScreen> createState() => _AddQualificationScreen();
}

class _AddQualificationScreen extends State<AddQualificationScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];
  final _fromkey = GlobalKey<FormState>();
  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");
  DateTime _date = DateTime.now();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperQualification4.getsingleDataQualification(
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester,
        widget.idstudent,
        widget.name,
        widget.lastname,
        widget.cedula);
    //final data2 = await DBHelperQualification3.getAllData();
    setState(() {
      _allData = data;
      //_allData = data2;
      _isLoading = false;
      print(_allData);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _evaluationController.dispose();
    _qualificationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  final TextEditingController _evaluationController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showDialogList(int? id) async {
    bool isNewQualification = id == null;
    String dialogTitle =
        isNewQualification ? 'Agregar Calificación' : 'Actualizar Calificación';
    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _evaluationController.text = existingData['evaluation'];
      _qualificationController.text = existingData['qualification'];
      _dateController.text = existingData['date'];
      print(_allData);
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
                controller: _evaluationController,
                decoration: InputDecoration(
                    hintText: 'Evaluación',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(
                    hintText: 'Calificación',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                controller: _dateController,
                style: const TextStyle(fontSize: 18.0),
                onTap: _handleDatePicker,
                decoration: InputDecoration(
                  labelText: "fecha",
                  labelStyle: const TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _evaluationController.text = '';
              _qualificationController.text = "";
              _dateController.text = "";
            },
          ),
          ElevatedButton(
            child: Text(id == null ? 'Agregar Calificación' : 'Actualizar'),
            onPressed: () async {
              if (_fromkey.currentState!.validate()) {
                if (id == null) {
                  await _addData();
                }

                if (id != null) {
                  await _updateData(id);
                }

                // Clear the text fields
                _evaluationController.text = '';
                _qualificationController.text = "";
                _dateController.text = "";

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
        content: const Text(
            '¿Estás seguro de que quieres eliminar este calificación?'),
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
    await DBHelperQualification4.createData(
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester,
        widget.idstudent,
        widget.name,
        widget.lastname,
        widget.cedula,
        _evaluationController.text,
        _qualificationController.text,
        _dateController.text);
    _refreshData();
  }

  // Update an existing period
  Future<void> _updateData(int id) async {
    await DBHelperQualification4.updateData(
        id,
        widget.period,
        widget.career,
        widget.subject,
        widget.section,
        widget.semester,
        widget.idstudent,
        widget.name,
        widget.lastname,
        widget.cedula,
        _evaluationController.text,
        _qualificationController.text,
        _dateController.text);
    _refreshData();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DBHelperQualification4.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('eliminaste un calificación'),
    ));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 227, 229, 234),
        centerTitle: true,
        title: Text(
          "lista de calificaciones",
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
                "${widget.period} > ${widget.career} > ${widget.subject} > ${widget.section} > ${widget.semester}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.name}, ${widget.lastname} C.I: ${widget.cedula}",
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
                      color: Colors.blueAccent[100],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Evaluacion: ${_allData[index]['evaluation']}",
                              style: const TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Nota: ${_allData[index]["qualification"]}",
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            _allData[index]['date'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  _showDialogList(_allData[index]['id']),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
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
        onPressed: () => _showDialogList(null),
      ),
    );
  }
}
