import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crud3/database_handler.dart';
import 'package:crud3/user_model.dart';
import 'user_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController ageController=TextEditingController();

  Database? _database;

  List<Map<String, dynamic>>? usersList;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New User',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',

                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                 controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',

                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Age',
                    labelText: 'Age',

                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        insertDB();

                      },
                      child: const Text('Save Details'),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                          onPressed: () {
                        getFromUser();

                      },
                      child: const Text('Read Details'),
                  ),

                ],
              ),
              /*if(usersList!=null) buildUserList()*/
            ],
          ),
        ),
      ),
    );
  }
/*
  Widget buildUserList(){
    return Expanded(child:
      ListView.builder(
        itemCount: usersList?.length,
        itemBuilder: (BuildContext context, int index){
          return Text("${usersList?[index]['name']}");
        },
        *//*itemBuilder: (BuildContext context, int index){
        return Text("USER NAME ${usersList?[index]['name']}");
        }*//*
    ),
    );
}*/

  Future<Database?> openDB() async{
    _database=await DatabaseHandler().openDB();
    return _database;
  }
  Future<void> insertDB() async{
    _database=await openDB();

    UserRepo userRepo= UserRepo();
    userRepo.createTable(_database);
    
    UserModel userModel= UserModel(
        nameController.text.toString(),
        emailController.text.toString(),
        int.tryParse(ageController.text.toString())!
    );

    await _database?.insert('user', userModel.toMap());
    await _database?.close();
  }

  Future<void> getFromUser() async{

    _database= await openDB();

    UserRepo userRepo= UserRepo();
    usersList=await userRepo.getUsers(_database);
    await _database?.close();
  }
}
