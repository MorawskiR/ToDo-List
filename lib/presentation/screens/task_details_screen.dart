import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task, required this.onSave});

  final Task task;
  final Function(Task) onSave;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {


late TextEditingController _titleController;

@override
void initState(){
  super.initState();
  _titleController = TextEditingController(text:widget.task.title);
}

@override
void dispose(){
  _titleController.dispose();
  super.dispose();
}

void _saveCahanges(){
  String newTitle = _titleController.text.trim();
  if(newTitle.isNotEmpty){
    widget.onSave(Task(title:newTitle, isCompleted: widget.task.isCompleted));
    Navigator.pop(context);
  } else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('tytul nie moze byc pusty')));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('szczegoly zadania'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Tytul zadaia'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveCahanges),
    );
  }
}