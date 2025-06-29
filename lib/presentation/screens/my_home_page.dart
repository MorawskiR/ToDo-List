import 'package:flutter/material.dart';
import 'package:todo_list_app/data/local_storage.dart';
import 'package:todo_list_app/data/quote_service.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/presentation/screens/task_details_screen.dart';
import 'package:todo_list_app/presentation/widgets/task_item.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocalStorage localStorage = LocalStorage();
  QuoteService quoteService = QuoteService();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

@override
void initState(){
  super.initState();
  loadData();
}

Future<void> getQuote() async {
  String? quote = await quoteService.fetchRandomQuote();
  if(quote != null){
    addTask(quote);
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('nie udalo sie pobrac')),
    );
  }
}

void addTask(String title){
  setState(() {
    tasks.insert(0,Task(title:title));
    listKey.currentState?.insertItem(0);
  });
  saveData();
}

Future<void> loadData() async{
  List<Task> loadedTasks = await localStorage.loadTasks();
  setState((){
    tasks = loadedTasks;
    listKey.currentState?.insertAllItems(0, tasks.length);
  });
}

Future<void> saveData() async {
  await localStorage.saveTasks(tasks);
}

Future<void> removeTask(int index) async
{
      final removedItem = tasks[index];
             // addTask(controller.text);
              setState(() {
                tasks.removeAt(index);
              });
              listKey.currentState?.removeItem(index, (context,animation) => TaskItem(
                animation: animation,
              task: removedItem,
              onEdit: () {},
              onDelete: () {},
              onTap: () {},
              ),
              );
              await saveData();
}


void toggleTask(Task task){
  setState(() {
    task.isCompleted = !task.isCompleted;
  }); saveData();
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
   
      body: AnimatedList(
        key: listKey,
        initialItemCount: tasks.length, 
        itemBuilder: (context, index, animation) {
        return TaskItem(onEdit: () => goToTaskDetails(tasks[index]),
        onDelete:() => removeTask(index) ,
        onTap: () => toggleTask(tasks[index]), task: tasks[index], animation: animation,
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
              addTask(controller.text);
              // setState(() {
              // tasks.add(Task(title: controller.text));
              // });
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