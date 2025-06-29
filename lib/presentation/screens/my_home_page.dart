import 'package:flutter/material.dart';
import 'package:todo_list_app/data/local_storage.dart';
import 'package:todo_list_app/data/quote_service.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/presentation/screens/task_details_screen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocalStorage localStorage = LocalStorage();
  QuoteService quoteService = QuoteService();

@override
void initState(){
  super.initState();
  loadData();
}

Future<void> getQuote() async {
  String? quote = await quoteService.fetchRandomQuote();
  if(quote != null){
    addQuoteToTask(quote);
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('nie udalo sie pobrac')),
    );
  }
}

void addQuoteToTask(String title){
  setState(() {
    tasks.add(Task(title:title));
  });
  saveData();
}

Future<void> loadData() async{
  List<Task> loadedTasks = await localStorage.loadTasks();
  setState((){
    tasks = loadedTasks;
  });
}

Future<void> saveData() async {
  await localStorage.saveTasks(tasks);
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
   
      body: ListView.builder(itemCount: tasks.length, itemBuilder: (context, index) {
        return ListTile(
          onLongPress: () =>  goToTaskDetails(tasks[index]),
          leading: Icon(tasks[index].isCompleted ? Icons.check_box : Icons.check_box_outline_blank_outlined,
          ),
          trailing: IconButton(onPressed: () async {
            setState(() {
              tasks.removeAt(index);
            });
            await saveData();
          }, icon: Icon(Icons.delete),),
          title: Text(
            tasks[index].title, 
            style: TextStyle(
              decoration: tasks[index].isCompleted ? TextDecoration.lineThrough : null,
          ),
      ), onTap: () async { 
        setState(() {

          tasks[index].isCompleted = !tasks[index].isCompleted;
        });
        await saveData();
      },
    );
  },),
    
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [    FloatingActionButton(
          onPressed: () => getQuote(),
        child: Icon(Icons.format_quote_outlined),
        tooltip: 'Dodaj losowy cytat',
      ),
      SizedBox(height: 20,),
        FloatingActionButton(
          onPressed: () => showTaskDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Dodaj zadanie',
           ),
      ],
    ),
  );
}

void goToTaskDetails(Task task){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailsScreen(
        task: task, 
        onSave: (updatedTask) {
          setState(() {
           int index = tasks.indexOf(task) ;
           tasks[index] = updatedTask;

          });
        },
        ),
  ),
  );
}
void showTaskDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();
final formKey = GlobalKey<FormState>();
  showDialog(context: context, builder: 
   (context) {
    return AlertDialog(
      title: Text('Dodaj nowe zadanie'),
      content: Form(
        key: formKey,
        child: TextFormField(
        validator: (value){
          if(value ==null || value.trim().isEmpty){
            return 'Wprowadz prosze tresc zadania';
          }
          else 
          {
            return null;
          }
        },
        controller: controller,
        decoration: InputDecoration(hintText: 'wprowadz tresc zadania'),
        ),
      ),
      actions: [
        TextButton(
        child: Text('Anuluj'),
        onPressed: () {Navigator.of(context).pop();},
        ),
        TextButton(
          onPressed: () {
            if(formKey.currentState!.validate()) {
              setState(() {
              tasks.add(Task(title: controller.text));
              });
              saveData();
              Navigator.of(context).pop();
            }
          
          },
          child: Text('Dodaj'))
      ],
    );
   } 
   );
}
}






// var task = Task(isCompleted: = false, title: 'zadanie1');