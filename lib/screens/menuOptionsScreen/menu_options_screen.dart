import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/attendanceScreen/attendance_screen.dart';
import 'package:uniprocess_app/screens/menuOptionsScreen/db_helper_menu_options.dart';
import 'package:uniprocess_app/screens/qualificationScreen/qualification_screen.dart';
import 'package:uniprocess_app/screens/studentsList/students_list_screen.dart';

class MenuOptionsScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  const MenuOptionsScreen(
      {super.key,
      required this.period,
      required this.career,
      required this.subject,
      required this.section,
      required this.semester});

  @override
  State<MenuOptionsScreen> createState() => _MenuOptionsScreenState();
}

class _MenuOptionsScreenState extends State<MenuOptionsScreen> {
  // All journals
  List<Map<String, dynamic>> _allData = [];

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DBHelperMenuOptions.getsingleDataMenu(widget.period,
        widget.career, widget.subject, widget.section, widget.semester);
    setState(() {
      _allData = data;
    });
    print(data);
    print(_allData.length);
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(193, 234, 233, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 229, 227, 236),
        centerTitle: true,
        toolbarHeight: 150,
        title: Text(
          """    ${widget.period} - ${widget.career} 
          ${widget.subject} -${widget.section} 
          ${widget.semester}  
    Menu de opciones""",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Card(
            color: Colors.lime[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return StudentsListScreen(
                        period: widget.period,
                        career: widget.career,
                        subject: widget.subject,
                        section: widget.section,
                        semester: widget.semester,
                      );
                    }),
                  );
                },
                title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.subject,
                      style: const TextStyle(fontSize: 20),
                    )),
                subtitle: const Text(
                  "Lista de Estudiantes",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                trailing: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: const Icon(Icons.arrow_circle_down),
                )),
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.lime[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AttendanceScreen(
                        period: widget.period,
                        career: widget.career,
                        subject: widget.subject,
                        section: widget.section,
                        semester: widget.semester,
                      );
                    }),
                  );
                },
                title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.subject,
                      style: const TextStyle(fontSize: 20),
                    )),
                subtitle: const Text(
                  "Lista de Asistencias",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                trailing: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: const Icon(Icons.arrow_circle_down),
                )),
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.lime[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return QualificationScreen();
                    }),
                  );
                },
                title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      widget.subject,
                      style: const TextStyle(fontSize: 20),
                    )),
                subtitle: const Text(
                  "Lista de Notas",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                trailing: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: const Icon(Icons.arrow_circle_down),
                )),
          )
        ],
      ),
    );
  }
}
