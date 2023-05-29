import 'package:flutter/material.dart';
import 'package:uniprocess_app/screens/HomeScreen/add_update_note_screen.dart';
import 'package:uniprocess_app/screens/HomeScreen/db_helper_note.dart';
import 'package:uniprocess_app/screens/HomeScreen/model_note.dart';

class HomeScreen extends StatefulWidget {
  static const String name = "Home_Screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          "UNIPROCESS",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              iconSize: 30.0,
              onPressed: () {},
              icon: Icon(Icons.supervised_user_circle_sharp),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Text(
              "bienvenido a esta aplicacion",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 50, 53),
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
              child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.app_registration_outlined),
                  label: const Text("crea una lista"))),
          const SizedBox(
            height: 20.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Mis Notas",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 50, 53),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: dataList,
                  builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "no hay registro",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          int todoId = snapshot.data![index].id!.toInt();
                          String todoTitle =
                              snapshot.data![index].title.toString();
                          String todoDesc =
                              snapshot.data![index].desc.toString();
                          String todoDT =
                              snapshot.data![index].dateandtime.toString();
                          return Dismissible(
                            key: ValueKey<int>(todoId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent,
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(todoId);
                                dataList = dbHelper!.getDataList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(93, 87, 76, 144),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        todoTitle,
                                        style: const TextStyle(fontSize: 19),
                                      ),
                                    ),
                                    subtitle: Text(
                                      todoDesc,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          todoDT,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddUpdateTask(
                                                          todoid: todoId,
                                                          todoTitle: todoTitle,
                                                          todoDesc: todoDesc,
                                                          todoDT: todoDT,
                                                          update: true,
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.edit_note_outlined,
                                            size: 30,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateTask()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
