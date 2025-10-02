import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_todo_app/To%20Do%20App/hive_db.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final myBox = Hive.box("todos");
  final TextEditingController _controller = TextEditingController();
  TodoApp db = TodoApp();

  @override
  void initState() {
    if(myBox.get("TODOLIST")== null){
      print('empty');
    }else{
      db.loadData();
    }
    super.initState();
  }

    void saveTask(){
        if(_controller.text.isNotEmpty){
         setState(() {
            db.todoList.add([_controller.text, false]);
          _controller.clear();
         });
         Navigator.pop(context);
         db.updateData();
        }
    }
    void checkboxOperation(bool ? value, int index){ 
        setState(() {
          db.todoList[index][1] = !db.todoList[index][1];
        });
        db.updateData();
    }

  void createTodo() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.blue,
              content: SizedBox(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Add a new todo"
                              ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      //for save button
                      MaterialButton(onPressed: saveTask, color: Colors.white,child: Text('Save'),
                      ),
                      //for cancel
                       MaterialButton(onPressed: ()=> Navigator.pop(context),
                        color: Colors.white,child: Text('Cancel'),
                      ),
                    ],)
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: db.todoList.isEmpty ? Center(child:
       Text('No items added yet, plz add a task'),
       ) :
      ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Slidable(
              endActionPane: ActionPane(motion: StretchMotion(), 
              children: [
                SlidableAction(onPressed: (context){
                    setState(() {
                      db.todoList.removeAt(index);
                    });
                    db.updateData();
                }, 
                icon: Icons.delete, backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(10),)
              ]),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                        value: db.todoList[index][1],
                        onChanged: (value) => checkboxOperation(value,index),
                        activeColor: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        db.todoList[index][0],
                        style: TextStyle(
                          decoration: db.todoList[index][1]
                          ? TextDecoration.lineThrough : null,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: db.todoList[index][1] ? Colors.black : 
                            Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
