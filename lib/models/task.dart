

class Task{
  String title;
  bool isCompleted;

  Task({this.isCompleted = false, required this.title});
}

List<Task> tasks = [Task(title:'zadanie1'),Task(title: 'zadanie2'),Task(title: 'zadanie3')];