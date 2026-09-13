import 'package:flutter/material.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/services/urls.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  bool _getTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  Future<void> _getCompletedTasks() async {
    if (!mounted) return;
    setState(() => _getTasksInProgress = true);

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskListByStatus('Completed'),
    );

    if (!mounted) return;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.responseData);
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    setState(() => _getTasksInProgress = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: BackgroundWidget(
        child: RefreshIndicator(
          onRefresh: _getCompletedTasks,
          child: Visibility(
            visible: !_getTasksInProgress,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: (_taskListModel.taskList == null ||
                    _taskListModel.taskList!.isEmpty)
                ? const Center(
                    child: Text(
                      'No completed tasks found!',
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
                        onRefresh: _getCompletedTasks,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
