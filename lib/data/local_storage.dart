
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/models/task.dart';

class LocalStorage {

  static const String _key = 'taskList';

  Future<void> saveTasks(List<Task> tasks) async {
   try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> taskList = tasks.map((task) => jsonEncode(
          {
            'title': task.title, 'isCompleted': task.isCompleted
          },
        )) .toList();
        await prefs.setStringList(_key, taskList);
   } catch(error){
    print('blad opdczas zapisu danych $error');
   }
  }


  Future<List<Task>> loadTasks() async {
    try{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? taskList = prefs.getStringList(_key);
        if(taskList != null){
          return taskList.map((task){
            Map<String, dynamic> map = jsonDecode(task);
            return Task(title: map['title'], isCompleted: map['isCompleted']);
          }).toList();
        } else{
          return [];
        }
      } catch(error){
      print('blad opdczas zapisu danych $error');
      return [];
    }
    }
}

