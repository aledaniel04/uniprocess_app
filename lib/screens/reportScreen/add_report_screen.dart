import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniprocess_app/screens/reportScreen/db_helper_report.dart';
import 'package:uniprocess_app/screens/reportScreen/report_model.dart';
import 'package:uniprocess_app/screens/reportScreen/report_screen.dart';

class AddReportScreen extends StatefulWidget {
  final Report? report;
  final Function? updateReportList;

  const AddReportScreen({super.key, this.report, this.updateReportList});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  String _week = "";
  String _sede = "Sede Coro";
  String _docente = "";
  String _carrera = "Ing. Sistema (Coro)";
  //String _asignatura = "";
  String _estudiantes = "";
  String _estudiantespresent = "";
  String _unidad = "";
  String _evaluacion = "";
  String _observaciones = "";
  String btnText = "agregar reporte";
  String titleText = "agregar reporte";

  final TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyy");
  final List<String> _sedess = ["Sede Coro", "Extension Punto Fijo"];
  final List<String> _carrerass = [
    "TSU Turismo(Coro)",
    "TSU Turismo (Punto Fijo)",
    "TSU Enfermeria",
    "Administracion de Desastre",
    "Economia Social (Coro)",
    "Economia Scial (Punto Fijo)",
    "Gestion Municipal",
    "Ing. Sistema (Coro)",
    "Ing. Sistema (Punto Fijo)",
    "Ing. Petroquimica (Coro)",
    "Ing. Petroquimica (Punto Fijo)",
    "Ing. Telecomunicaciones",
    "Ing. Naval",
    "CINU (Coro)",
    "CINU (pUNTO fijo)"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      _week = widget.report!.week!;
      _date = widget.report!.date!;
      _sede = widget.report!.sede!;
      _date = widget.report!.date!;
      _docente = widget.report!.docente!;
      _carrera = widget.report!.carrera!;
      //_asignatura = widget.report!.asignatura!;
      _estudiantes = widget.report!.estudiantes!;
      _estudiantespresent = widget.report!.estudiantespresent!;
      _unidad = widget.report!.unidad!;
      _evaluacion = widget.report!.evaluacion!;
      _observaciones = widget.report!.observaciones!;

      setState(() {
        btnText = "actualizar Reporte";
        titleText = "actualizar Reporte";
      });
    } else {
      setState(() {
        btnText = "agregar Reporte";
        titleText = "agregar Reporte";
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _delete() {
    DBHelperReport.instance.deleteReport(widget.report!.id!);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ReportScreen()));
    if (widget.updateReportList != null) {
      widget.updateReportList!();
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Report report = Report(
          week: _week,
          date: _date,
          sede: _sede,
          docente: _docente,
          carrera: _carrera,
          //asignatura: _asignatura,
          estudiantes: _estudiantes,
          estudiantespresent: _estudiantespresent,
          unidad: _unidad,
          evaluacion: _evaluacion,
          observaciones: _observaciones);

      if (widget.report == null) {
        DBHelperReport.instance.insertReport(report);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ReportScreen()));
      } else {
        report.id = widget.report!.id;
        DBHelperReport.instance.updateReport(report);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ReportScreen()));
      }
      if (widget.updateReportList != null) {
        widget.updateReportList!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 139, 181, 252),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ReportScreen())),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  titleText,
                  style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Semana",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _week = input!,
                          initialValue: _week,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: const TextStyle(fontSize: 8.0),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                              labelText: "fecha",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
                          iconSize: 12.0,
                          iconDisabledColor: Theme.of(context).primaryColor,
                          items: _sedess.map((String sede) {
                            return DropdownMenuItem(
                              value: sede,
                              child: Text(
                                sede,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "sede",
                              labelStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                          validator: (input) =>
                              _sedess == null ? "seleccione una sede" : null,
                          onChanged: (value) {
                            setState(() {
                              _sede = value.toString();
                            });
                          },
                          value: _sede,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Nombre del Docente",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _docente = input!,
                          initialValue: _docente,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items: _carrerass.map((String carrera) {
                            return DropdownMenuItem(
                              value: carrera,
                              child: Text(
                                carrera,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "carreras",
                              labelStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                          validator: (input) =>
                              _carrerass == null ? "seleccione una sede" : null,
                          onChanged: (value) {
                            setState(() {
                              _carrera = value.toString();
                            });
                          },
                          value: _carrera,
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "asignatura",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _asignatura = input!,
                          initialValue: _asignatura,
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Estudiantes Inscritos",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _estudiantes = input!,
                          initialValue: _estudiantes,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Estudiantes Presentes",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _estudiantespresent = input!,
                          initialValue: _estudiantespresent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Uniadad",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _unidad = input!,
                          initialValue: _unidad,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Evaluacion",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _evaluacion = input!,
                          initialValue: _evaluacion,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: "Observaciones",
                              labelStyle: const TextStyle(fontSize: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? "campo obligatorio"
                              : null,
                          onSaved: (input) => _observaciones = input!,
                          initialValue: _observaciones,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 30.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              btnText,
                              style: const TextStyle(fontSize: 20.0),
                            )),
                      ),
                      widget.report != null
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              height: 30.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: ElevatedButton(
                                onPressed: _delete,
                                child: const Text(
                                  "eliminar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
