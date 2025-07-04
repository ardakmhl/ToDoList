import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ToDoHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});
  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  static const List<String> categories = ['İş', 'Ev', 'Alışveriş', 'Diğer'];
  String selectedCategory = categories[0];

  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  void addTasks() {
    String text = taskController.text;
    if (text.isNotEmpty) {
      setState(() {
        tasks.add({'title': text, 'done': false, 'category': selectedCategory});
      });
      taskController.clear();
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleDone(int index, bool? value) {
    setState(() {
      tasks[index]['done'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = tasks
        .where((task) => task['category'] == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 125, 25),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 173, 98, 18),
        centerTitle: true,
        title: const Text("Görev Ağacı", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: categories.map((cat) {
                bool isSelected = cat == selectedCategory;

                bool hasPending = tasks.any(
                  (task) => task['category'] == cat && task['done'] == false,
                );

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.orange.shade700
                            : const Color.fromARGB(255, 255, 129, 129),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      child: Text(cat),
                    ),
                    if (hasPending)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Yapacağınız görevi giriniz.',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 100, 63, 51),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 60, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addTasks,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                var task = filteredTasks[index];
                int originalIndex = tasks.indexOf(task);

                return Card(
                  color: const Color.fromARGB(255, 161, 73, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: task['done'],
                      onChanged: (value) => toggleDone(originalIndex, value),
                      activeColor: Colors.white,
                      checkColor: const Color.fromARGB(255, 25, 125, 25),
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        color: Colors.white,
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 204, 204),
                      ),
                      onPressed: () => deleteTask(originalIndex),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
