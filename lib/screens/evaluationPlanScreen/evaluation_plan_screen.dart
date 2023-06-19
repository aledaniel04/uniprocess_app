import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/evaluationPlanScreen/db_helper_evaluationPlan.dart';
import 'package:intl/intl.dart';

class EvaluationPlanScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;

  const EvaluationPlanScreen({
    Key? key,
    required this.period,
    required this.career,
    required this.subject,
    required this.section,
    required this.semester,
  }) : super(key: key);

  @override
  State<EvaluationPlanScreen> createState() => _EvaluationPlanScreenState();
}

class _EvaluationPlanScreenState extends State<EvaluationPlanScreen> {
  List<Map<String, dynamic>> _allData = [];
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");
  DateTime _date = DateTime.now();

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperEvaluationPlan.getsingleDataStudenstList(
      widget.period,
      widget.career,
      widget.subject,
      widget.section,
      widget.semester,
    );
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _assessmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
    _dateController.text =
        _dateFormatter.format(_date); // Loading the diary when the app starts
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    _assessmentController.dispose();
    super.dispose();
  }

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

  void _showDialogEvaluation(int? id) async {
    bool isNewCareer = id == null;
    String dialogTitle = isNewCareer ? 'Nuevo Unidad' : 'Actualizar Unidad';
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _objectiveController.text = existingData['objective'];
      _contentController.text = existingData['content'];
      _dateController.text = existingData['date'];
      _assessmentController.text = existingData['assessment'];
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
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _objectiveController,
                  decoration: InputDecoration(
                    hintText: 'Objetivo de la Unidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Contenido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _assessmentController,
                  decoration: InputDecoration(
                    hintText: 'instrumento de evaluacion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
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
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _objectiveController.text = '';
              _contentController.text = '';
              _dateController.text = '';
              _assessmentController.text = '';
            },
          ),
          ElevatedButton(
            child: Text(id == null ? 'Agregar Unidad' : 'Actualizar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (id == null) {
                  await _addData();
                } else {
                  await _updateData(id);
                }

                _objectiveController.text = '';
                _contentController.text = '';
                _dateController.text = '';
                _assessmentController.text = '';

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
            const Text('¿Estás seguro de que quieres eliminar esta Unidad?'),
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

  Future<void> _addData() async {
    await DBHelperEvaluationPlan.createData(
      widget.period,
      widget.career,
      widget.subject,
      widget.section,
      widget.semester,
      _objectiveController.text,
      _contentController.text,
      _dateController.text,
      _assessmentController.text,
    );
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await DBHelperEvaluationPlan.updateData(
      id,
      widget.period,
      widget.career,
      widget.subject,
      widget.section,
      widget.semester,
      _objectiveController.text,
      _contentController.text,
      _dateController.text,
      _assessmentController.text,
    );
    _refreshData();
  }

  void _deleteItem(int id) async {
    await DBHelperEvaluationPlan.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('eliminaste un estudiantes'),
      ),
    );
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 229, 227, 236),
        centerTitle: true,
        title: const Text(
          "Plan de evaluación",
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
                    shrinkWrap: true,
                    itemCount: _allData.length,
                    itemBuilder: (context, index) => Card(
                      margin: const EdgeInsets.all(15),
                      child: InkWell(
                        onLongPress: () => _showDeleteConfirmationDialog(
                            _allData[index]['id']),
                        child: Column(children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            onTap: () =>
                                _showDialogEvaluation(_allData[index]['id']),
                            title: Text(
                              _allData[index]['objective'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    2000, // Ajusta esta altura máxima según tus necesidades
                              ),
                              child: Text(
                                _allData[index]["content"],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            /*trailing: Container(
                            width: 120, // Ajusta este valor según tus necesidades
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _allData[index]['date'],
                                      style: const TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Flexible(
                                  child: Text(
                                    _allData[index]['assessment'],
                                    style: const TextStyle(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 0.8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " ${_allData[index]['date']}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  " ${_allData[index]['assessment']}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _showDialogEvaluation(null),
          ),
        ),
      ),
    );
  }
}
