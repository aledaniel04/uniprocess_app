import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniprocess_app/screens/reportScreen/add_report_screen.dart';
import 'package:uniprocess_app/screens/reportScreen/db_helper_report.dart';
import 'package:uniprocess_app/screens/reportScreen/report_model.dart';
import 'package:flutter/widgets.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<Report>> _reportList;

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  final DBHelperReport _dbHelperReport = DBHelperReport.instance;

  @override
  void initState() {
    super.initState();
    _updateReportList();
  }

  _updateReportList() {
    _reportList = DBHelperReport.instance.getNoteList();
    print(_reportList);
  }

  Widget _buildNote(BuildContext context, Report report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              report.week!,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              "${_dateFormatter.format(report.date!)} - ${report.sede}",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddReportScreen(
                  updateReportList: _updateReportList(),
                  report: report,
                ),
              ),
            ),
          ),
          const Divider(
            height: 5.0,
            color: Colors.black,
            thickness: 2.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddReportScreen(
                  updateReportList: _updateReportList,
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _reportList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: int.parse(snapshot.data!.length.toString()) + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Reportes",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "${snapshot.data.length}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }
                return _buildNote(context, snapshot.data![index - 1]);
              },
            );
          }),
    );
  }
}
