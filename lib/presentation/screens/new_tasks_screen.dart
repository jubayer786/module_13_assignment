import 'package:flutter/material.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/services/urls.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import '../widgets/task_counter_card.dart';
import 'add_new_task_screen.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool _getTasksInProgress = false;
  bool _getCountInProgress = false;
  TaskListModel _taskListModel = TaskListModel();
  TaskCountListModel _taskCountListModel = TaskCountListModel();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _getTaskStatusCount(),
      _getNewTasks(),
    ]);
  }

  Future<void> _getNewTasks() async {
    if (!mounted) return;
    setState(() => _getTasksInProgress = true);

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskListByStatus('New'),
    );

    if (!mounted) return;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.responseData);
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    setState(() => _getTasksInProgress = false);
  }

  Future<void> _getTaskStatusCount() async {
    if (!mounted) return;
    setState(() => _getCountInProgress = true);

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskStatusCount,
    );

    if (!mounted) return;
    if (response.isSuccess) {
      _taskCountListModel = TaskCountListModel.fromJson(response.responseData);
    }

    setState(() => _getCountInProgress = false);
  }

  int _getStatusCount(String status) {
    if (_taskCountListModel.statusCountList == null) return 0;
    for (var item in _taskCountListModel.statusCountList!) {
      if (item.sId?.toLowerCase() == status.toLowerCase()) {
        return item.sum ?? 0;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: BackgroundWidget(
        child: RefreshIndicator(
          onRefresh: _fetchInitialData,
          child: Column(
            children: [
              _buildTaskCountCards(),
              Expanded(
                child: Visibility(
                  visible: !_getTasksInProgress,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: (_taskListModel.taskList == null ||
                          _taskListModel.taskList!.isEmpty)
                      ? const Center(
                          child: Text(
                            'No new tasks found!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _taskListModel.taskList!.length,
                          itemBuilder: (context, index) {
                            return TaskCard(
                              task: _taskListModel.taskList![index],
                              onRefresh: _fetchInitialData,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        onPressed: () async {
          final bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
          if (shouldRefresh == true) {
            _fetchInitialData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCountCards() {
    return SizedBox(
      height: 96,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Visibility(
          visible: !_getCountInProgress,
          replacement: const Center(
            child: LinearProgressIndicator(),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              TaskCounterCard(
                count: _getStatusCount('New'),
                title: 'New Task',
              ),
              TaskCounterCard(
                count: _getStatusCount('Completed'),
                title: 'Completed',
              ),
              TaskCounterCard(
                count: _getStatusCount('Canceled'),
                title: 'Cancelled',
              ),
              TaskCounterCard(
                count: _getStatusCount('Progress'),
                title: 'In Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
