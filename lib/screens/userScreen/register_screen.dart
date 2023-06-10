import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? selectedOption;

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes guardar los datos o realizar alguna acción
      print('Datos guardados:');
      print('Opción seleccionada: $selectedOption');
      print('Nombre: ${_nameController.text}');
      print('Apellidos: ${_lastNameController.text}');
      print('Correo electrónico: ${_emailController.text}');
      print('Número telefónico: ${_phoneNumberController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 250,
                  child: Image(
                    image: AssetImage("assets/imagen/img1.png"),
                    fit: BoxFit.contain,
                  ),
                ),
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
                            child: Text('Guardar datos'),
                            style: ButtonStyle(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al hacer clic en "Siguiente"
                            },
                            child: Text('Siguiente'),
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
