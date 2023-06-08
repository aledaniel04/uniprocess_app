import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/attendanceScreen/db_helper_attendance.dart';
import 'package:uniprocess_app/screens/studentsList/db_helper_students_list.dart';

class QualificationScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  //static const String name = "Period_Screen";
  const QualificationScreen(
      {super.key,
      required this.period,
      required this.career,
      required this.subject,
      required this.section,
      required this.semester});

  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
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
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 242),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[600],
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
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.playlist_add_check,
                                size: 40,
                              ))),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
