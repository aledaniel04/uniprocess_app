import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniprocess_app/screens/HomeScreen/home_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? selectedOption;
  late SharedPreferences _prefs;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    _prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    print(_prefs);
    setState(() {
      selectedOption = prefs.getString('selectedOption');
      _nameController.text = prefs.getString('name') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneNumberController.text = prefs.getString('phoneNumber') ?? '';
    });
  }

  void _submitForm() async {
    _prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await _prefs;
      await prefs.setString('selectedOption', selectedOption!);
      await prefs.setString('name', _nameController.text);
      await prefs.setString('lastName', _lastNameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('phoneNumber', _phoneNumberController.text);
      Fluttertoast.showToast(
        msg: '¡Los datos se actualizaron exitosamente!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }),
        );
      });
    }
  }

  void _clearData() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
    setState(() {
      selectedOption = null;
      _nameController.text = '';
      _lastNameController.text = '';
      _emailController.text = '';
      _phoneNumberController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de usuario"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: 240,
                    child: Icon(
                      Icons.person,
                      size: 250,
                    )),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedOption,
                        decoration: InputDecoration(
                          labelText: 'Seleccione una opción',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione una opción';
                          }
                          return null;
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'ING',
                            child: Text('ING'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'LIC',
                            child: Text('LIC'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'MSC',
                            child: Text('MSC'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'DR',
                            child: Text('DR'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un nombre válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese apellidos válidos';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un correo electrónico válido';
                          }
                          // Aquí puedes agregar una validación más específica para el correo electrónico
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Número telefónico',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un número telefónico válido';
                          }
                          // Aquí puedes agregar una validación más específica para el número telefónico
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Actualizar datos'),
                            style: ButtonStyle(),
                          ),
                          ElevatedButton(
                            onPressed: _clearData,
                            child: const Text('Eliminar datos'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
