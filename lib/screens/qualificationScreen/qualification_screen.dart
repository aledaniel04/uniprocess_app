import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/qualificationScreen/add_qualification_screen.dart';
import 'package:uniprocess_app/screens/qualificationScreen/db_helper_qualification.dart';
import 'package:uniprocess_app/screens/studentsList/db_helper_students_list.dart';

class QualificationScreen extends StatefulWidget {
  final String period;
  final String career;
  final String subject;
  final String section;
  final String semester;
  //static const String name = "Period_Screen";
  const QualificationScreen({
    super.key,
    required this.period,
    required this.career,
    required this.subject,
    required this.section,
    required this.semester,
  });

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

    final data2 = await DBHelperQualification3.getAllData();

    print("primera data: $data");
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
    print("segunda data $newData");
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return AddQualificationScreen(
                                  period: widget.period,
                                  career: widget.career,
                                  subject: widget.subject,
                                  section: widget.section,
                                  semester: widget.semester,
                                  idstudent: _allData[index]['id'],
                                  name: _allData[index]['name'],
                                  lastname: _allData[index]["lastname"],
                                  cedula: _allData[index]["cedula"],
                                );
                              }),
                            );
                          },
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
                                color: Colors.black87,
                              ))),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
