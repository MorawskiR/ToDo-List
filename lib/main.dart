import 'package:flutter/material.dart';

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
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
   
      body: ListView.builder(itemCount: tasks.length, itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(tasks[index].isCompleted ? Icons.check_box : Icons.check_box_outline_blank_outlined,
          ),
          trailing: IconButton(onPressed: () {
            setState(() {
              tasks.removeAt(index);
            });
          }, icon: Icon(Icons.delete),),
          title: Text(
            tasks[index].title, 
            style: TextStyle(
              decoration: tasks[index].isCompleted ? TextDecoration.lineThrough : null,
          ),
      ), onTap: () { 
        setState(() {
          
          tasks[index].isCompleted = !tasks[index].isCompleted;
        });
      },
    );
  },),
    
    floatingActionButton: FloatingActionButton(
      onPressed: () => showTaskDialog(context),
    child: Icon(Icons.add),
    tooltip: 'Dodaj zadanie',
   ),
  );
}
}

void showTaskDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();

  showDialog(context: context, builder: 
   (context) {
    return AlertDialog(
      title: Text('Dodaj nowe zadanie'),
      content: TextField(controller: controller,
      decoration: InputDecoration(hintText: 'wprowadz tresc zadania'),
      ),
    );
   } 
   );
}

List<Task> tasks = [Task(title:'zadanie1'),Task(title: 'zadanie2'),Task(title: 'zadanie3')];

class Task{
  String title;
  bool isCompleted;

  Task({this.isCompleted = false, required this.title});
}

// var task = Task(isCompleted: = false, title: 'zadanie1');