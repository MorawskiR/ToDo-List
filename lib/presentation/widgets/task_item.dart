import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task, required this.animation, required this.onTap, required this.onDelete, required this.onEdit});
  final Task task;
  final Animation<double> animation;
  final VoidCallback onTap;
  final VoidCallback onDelete;
 final VoidCallback onEdit;


  @override
  Widget build(BuildContext context) {
    return SizeTransition(
          sizeFactor: animation,
          child: ListTile(
            onLongPress:  onEdit,
            leading: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank_outlined,
            ),
            trailing: IconButton(onPressed: onDelete,          
            icon: Icon(Icons.delete),),
            title: AnimatedOpacity(
              opacity: task.isCompleted? 0.1 :1.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                task.title, 
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
              ),
                  ),
            ), onTap: onTap,
              ),
        );
  }
}