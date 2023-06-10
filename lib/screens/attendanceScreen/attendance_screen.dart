import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/attendanceScreen/db_helper_attendance.dart';
import 'package:uniprocess_app/screens/studentsList/db_helper_students_list.dart';

class AttendanceScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  //static const String name = "Period_Screen";
  const AttendanceScreen(
      {super.key,
      required this.period,
      required this.career,
      required this.subject,
      required this.section,
      required this.semester});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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

    final data2 = await DBHelperAttendence.getsingleDataAttendance(
      widget.period,
      widget.career,
      widget.subject,
      widget.section,
      widget.semester,
      "2023-06-05",
    );

    print(data);
    var newData = data.map((e) {
      var itemIndex =
          data2.indexWhere((element) => element["idstudent"] == e["id"]);
      // var assistance = itemIndex != -1 ? data2[itemIndex]["assistance"] : 0;
      print("item: $itemIndex");
      return {
        "idstudent": e["id"],
        "name": e["name"],
        "lastname": e["lastname"],
        "cedula": e["cedula"],
        "assistance": itemIndex != -1 ? data2[itemIndex]["assistance"] : 0,
      };
    }).toList();
    print(newData);
    setState(() {
      _allData = newData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }

  /*final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();*/

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  /*void _showBottomSheet(int? id) async {
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
  }*/

// Insert a new period to the database
  /* Future<void> _addData() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 229, 227, 236),
        centerTitle: true,
        title: Text(
          "lista de asistencias",
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
                        trailing: Checkbox(
                          value:
                              _allData[index]["assistance"] == 0 ? false : true,
                          onChanged: (bool? value) {
                            var nuevo = _allData;
                            setState(() {
                              _isLoading = true;
                            });
                            nuevo[index]["assistance"] = value! ? 1 : 0;
                            setState(() {
                              _isLoading = false;
                              _allData = nuevo;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
