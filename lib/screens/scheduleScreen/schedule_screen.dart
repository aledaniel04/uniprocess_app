import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/scheduleScreen/db_helper_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<Map<String, dynamic>> _allData;
  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  final List<String> hours = [
    '7:00-7:45',
    '7:45-8:30',
    '8:30-9:15',
    '9:15-10:00',
    '10:00-10:45',
    '10:45-11:30',
    '11:30-12:15',
    '12:15-1:00',
    '1:00-1:45',
    '1:45-2:30',
    '2:30-3:15',
    '3:15-4:00',
    '4:00-4:45',
    '4:45-5:30',
  ];

  late TextEditingController _dayController;
  late TextEditingController _hour1Controller;
  late TextEditingController _hour2Controller;
  late TextEditingController _subjectController;
  late TextEditingController _classroomController;

  @override
  void initState() {
    super.initState();
    _allData = List.generate(days.length * hours.length, (index) => {});
    _dayController = TextEditingController();
    _hour1Controller = TextEditingController();
    _hour2Controller = TextEditingController();
    _subjectController = TextEditingController();
    _classroomController = TextEditingController();
    _refreshData(); // Loading the diary when the app starts
  }

  @override
  void dispose() {
    _dayController.dispose();
    _hour1Controller.dispose();
    _hour2Controller.dispose();
    _subjectController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  void _refreshData() async {
    final data = await DBHelperSchedule.getAllData();
    setState(() {
      _allData = data;
    });
  }

  Widget _buildListTile(int index) {
    final item = _allData[index];
    final id = item['id'];

    return ListTile(
      onTap: () => _showDialogSchedule(id),
      title: Text(item['subject'] ?? 'Sin asignatura'),
      subtitle: Text(item['classroom'] ?? 'Sin aula'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.blueAccent,
            ),
            onPressed: () => _showDialogSchedule(id),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () => _showDeleteConfirmationDialog(id),
          ),
        ],
      ),
    );
  }

  void _showDialogSchedule(int? id) async {
    bool isNewPeriod = id == null;
    String dialogTitle = isNewPeriod ? 'Nuevo campo' : 'Actualizar campo';

    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _dayController.text = existingData['day'];
      _hour1Controller.text = existingData['hour1'];
      _hour2Controller.text = existingData['hour2'];
      _subjectController.text = existingData['subject'];
      _classroomController.text = existingData['classroom'];
    } else {
      _dayController.clear();
      _hour1Controller.clear();
      _hour2Controller.clear();
      _subjectController.clear();
      _classroomController.clear();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(dialogTitle),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _dayController.text.isEmpty ? null : _dayController.text,
                items: days.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _dayController.text = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Día',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione un día';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _hour1Controller.text.isEmpty
                    ? null
                    : _hour1Controller.text,
                items: hours.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _hour1Controller.text = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Hora inicio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione una hora';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _hour2Controller.text.isEmpty
                    ? null
                    : _hour2Controller.text,
                items: hours.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _hour2Controller.text = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Hora fin',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione una hora';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Asignatura',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una asignatura';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _classroomController,
                decoration: InputDecoration(
                  labelText: 'Aula',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un aula';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              _dayController.text;
              _hour1Controller.text;
              _hour2Controller.text;
              _subjectController.text;
              _classroomController.text;

              if (isNewPeriod) {
                await DBHelperSchedule.createData(
                    _dayController.text,
                    _hour1Controller.text,
                    _hour2Controller.text,
                    _subjectController.text,
                    _classroomController.text);
              } else {
                await DBHelperSchedule.updateData(
                    id,
                    _dayController.text,
                    _hour1Controller.text,
                    _hour2Controller.text,
                    _subjectController.text,
                    _classroomController.text);
              }

              _refreshData();
              Navigator.of(ctx).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Estás seguro de que deseas eliminar este campo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await DBHelperSchedule.deleteData(id);
              _refreshData();
              Navigator.of(ctx).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario'),
      ),
      body: PageView.builder(
        itemCount: _allData.length,
        itemBuilder: (ctx, index) => _buildListTile(index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialogSchedule(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
