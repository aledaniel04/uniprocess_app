import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/careerScreen/db_helper_caeer.dart';

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

  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showBottomSheet(int? id) async {
    if (id != null) {
      // id == null -> create new period
      // id != null -> update an existing period
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _careerController.text = existingData['career'];
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
                    controller: _careerController,
                    decoration: const InputDecoration(hintText: 'carrera'),
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

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(id == null ? 'Nuevo carrera' : 'Actualizar',
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
          "Carrra ${widget.period}",
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
                  title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['career'],
                        style: const TextStyle(fontSize: 20),
                      )),
                  subtitle: Text(widget.period),
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
