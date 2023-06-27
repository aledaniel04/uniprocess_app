import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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

  //final TextEditingController _asignaturaController = TextEditingController();

  double secondListTileHeight = 50.0; // Altura inicial del segundo ListTile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Horario"),
      ),
      body: PageView.builder(
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: days.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  days[index],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: hours.length,
                  itemBuilder: (context, hourIndex) {
                    return Row(
                      children: [
                        Container(
                          width: 135,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: ListTile(
                            title: Text(hours[hourIndex]),
                          ),
                        ),
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              secondListTileHeight += details.delta.dy;
                              secondListTileHeight = secondListTileHeight.clamp(
                                  50.0,
                                  200.0); // Limitar la altura entre 50 y 200
                            });
                          },
                          child: Container(
                            height: secondListTileHeight,
                            width: 257,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: ListTile(
                              title: Center(
                                child: Text("""Matematica Aula B2 """),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
