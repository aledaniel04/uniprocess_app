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

  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showBottomSheet(int? id) async {
    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _subjectController.text = existingData['subject'];
      _sectionController.text = existingData['section'];
      _semesterController.text = existingData['semester'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(hintText: 'asignatura'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _sectionController,
                    decoration: const InputDecoration(hintText: 'seccion'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _semesterController,
                    decoration: const InputDecoration(hintText: 'semestre'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Save new period
                        if (id == null) {
                          await _addData();
                        }

                        if (id != null) {
                          await _updateData(id);
                        }

                        // Clear the text fields
                        _periodController.text = '';
                        _careerController.text = "";
                        _subjectController.text = "";
                        _sectionController.text = "";
                        _semesterController.text = "";

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                            id == null ? 'Nuevo asignatura' : 'Actualizar',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  )
                ],
              ),
            ));
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
        toolbarHeight: 100,
        backgroundColor: Color.fromARGB(255, 229, 227, 236),
        centerTitle: true,
        title: Text(
          """${widget.period} - ${widget.career} 
          Asignatura """,
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
