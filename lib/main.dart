import 'package:flutter/material.dart';

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask(String title) {
    if (title.isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title));
      _taskController.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  List<String> _getSuggestions(String input) {
    if (input.isEmpty) return [];

    final suggestions = {
      'email': [
        'Reply to urgent emails',
        'Send weekly update email',
        'Clean email inbox',
        'Follow up on client email'
      ],
      'meeting': [
        'Prepare meeting agenda',
        'Schedule team sync',
        'Send meeting minutes',
        'Book conference room'
      ],
      'call': [
        'Call client for update',
        'Schedule phone meeting',
        'Return missed calls',
        'Team standup call'
      ],
      'report': [
        'Write weekly report',
        'Generate sales report',
        'Update project status',
        'Review analytics report'
      ],
      'deadline': [
        'Review project deadlines',
        'Submit pending work',
        'Check due dates',
        'Update timeline'
      ]
    };

    return suggestions.entries
        .where((entry) => input.toLowerCase().contains(entry.key))
        .expand((entry) => entry.value)
        .toList();
  }

  Widget _buildTasksList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => _toggleTask(_tasks.indexOf(task)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                        onTap: () {
                          Navigator.pop(context);
                          _showEditTaskDialog(task);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title:
                            Text('Delete', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(task);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Move this method outside of build, at class level
  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();
    final activeTasks = _tasks.where((task) => !task.isCompleted).toList();

    // Calculate completion percentage
    final completionPercentage = _tasks.isEmpty
        ? 0
        : (completedTasks.length / _tasks.length * 100).round();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Card with Gradient Border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(2),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            hintText: 'Add a new task...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _taskController,
                          builder: (context, value, child) {
                            final suggestions = _getSuggestions(value.text);
                            if (suggestions.isEmpty) return SizedBox.shrink();

                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Wrap(
                                spacing: 8,
                                children: suggestions
                                    .map(
                                      (suggestion) => ActionChip(
                                        label: Text(suggestion),
                                        avatar: Icon(Icons.add, size: 16),
                                        onPressed: () {
                                          _addTask(suggestion);
                                          _taskController.clear();
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Header with Gradient Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Statistics',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Enhanced Progress Container
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (rect) {
                                  return SweepGradient(
                                    startAngle: 0.0,
                                    endAngle: 3.14 * 2,
                                    stops: [
                                      completionPercentage / 100,
                                      completionPercentage / 100
                                    ],
                                    center: Alignment.center,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant
                                          .withOpacity(0.2),
                                    ],
                                  ).createShader(rect);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$completionPercentage%',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatItem(
                              'Active Tasks',
                              activeTasks.length.toString(),
                              Icons.pending_actions,
                              Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              'Completed',
                              completedTasks.length.toString(),
                              Icons.task_alt,
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Enhanced Task Cards
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    padding: const EdgeInsets.only(top: 8),
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Checkbox(
                              value: task.isCompleted,
                              onChanged: (_) =>
                                  _toggleTask(_tasks.indexOf(task)),
                              shape: CircleBorder(),
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () => _showTaskOptions(task),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Enhanced FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(),
          child: const Icon(Icons.add, color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Enter task description',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _addTask(_taskController.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final editController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: 'Enter new task description',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                task.title = editController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _tasks.remove(task);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTaskOptions(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              _showEditTaskDialog(task);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(task);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
