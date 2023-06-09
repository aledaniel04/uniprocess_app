import 'package:flutter/material.dart';

class NewHorarioScreen extends StatefulWidget {
  const NewHorarioScreen({Key? key}) : super(key: key);

  @override
  State<NewHorarioScreen> createState() => _NewHorarioScreenState();
}

class _NewHorarioScreenState extends State<NewHorarioScreen> {
  List<List<String>> horario = List.generate(10, (_) => List.filled(7, ""));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Usuario"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 70),
              const Text('Lunes'),
              const SizedBox(width: 10),
              const Text('Martes'),
              const SizedBox(width: 10),
              const Text('Miércoles'),
              const SizedBox(width: 10),
              const Text('Jueves'),
              const SizedBox(width: 10),
              const Text('Viernes'),
              const SizedBox(width: 10),
              const Text('Sábado'),
              const SizedBox(width: 10),
              const Text('Domingo'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      width: 70,
                      alignment: Alignment.centerRight,
                      child: Text('${formatHour(index)}'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50, // Establece una altura fija aquí
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (BuildContext context, int innerIndex) {
                            return GestureDetector(
                              onTap: () =>
                                  _showDialog(context, index, innerIndex),
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                alignment: Alignment.center,
                                child: Text('${horario[index][innerIndex]}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatHour(int index) {
    final startMinutes = index * 45;
    final endMinutes = startMinutes + 45;
    final startHour = convertMinutesToTimeOfDay(startMinutes);
    final endHour = convertMinutesToTimeOfDay(endMinutes);
    return '${formatTimeOfDay(startHour)} - ${formatTimeOfDay(endHour)}';
  }

  TimeOfDay convertMinutesToTimeOfDay(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return TimeOfDay(hour: 7 + hours, minute: remainingMinutes);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showDialog(BuildContext context, int rowIndex, int columnIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = horario[rowIndex][columnIndex];
        return AlertDialog(
          title: const Text('Agregar texto'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(hintText: 'Texto'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  horario[rowIndex][columnIndex] = inputText;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
