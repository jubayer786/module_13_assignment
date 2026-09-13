import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/services/urls.dart';
import 'snack_bar_message.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onRefresh;

  const TaskCard({
    super.key,
    required this.task,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              task.description ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${task.createdDate ?? ''}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(task.status ?? 'New'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.blue),
                      tooltip: 'Update Status',
                      onPressed: () => _showUpdateStatusDialog(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: 'Delete Task',
                      onPressed: () => _showDeleteConfirmDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'progress':
      case 'in progress':
        chipColor = Colors.purple;
        break;
      case 'canceled':
      case 'cancelled':
        chipColor = Colors.redAccent;
        break;
      case 'new':
      default:
        chipColor = const Color(0xFF2196F3);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context) {
    final List<String> statuses = ['New', 'Progress', 'Completed', 'Canceled'];
    String selectedStatus = task.status ?? 'New';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Update Task Status'),
              content: RadioGroup<String>(
                groupValue: selectedStatus,
                onChanged: (val) {
                  setStateDialog(() {
                    selectedStatus = val ?? 'New';
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: statuses.map((status) {
                    return RadioListTile<String>(
                      title: Text(status),
                      value: status,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _updateTaskStatus(context, selectedStatus);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateTaskStatus(BuildContext context, String newStatus) async {
    final response = await NetworkCaller.getRequest(
      Urls.updateTaskStatus(task.sId ?? '', newStatus),
    );

    if (context.mounted) {
      if (response.isSuccess) {
        showSnackBarMessage(context, 'Status updated to $newStatus');
        onRefresh();
      } else {
        showSnackBarMessage(context, response.errorMessage, true);
      }
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteTask(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    final response = await NetworkCaller.getRequest(
      Urls.deleteTask(task.sId ?? ''),
    );

    if (context.mounted) {
      if (response.isSuccess) {
        showSnackBarMessage(context, 'Task deleted successfully');
        onRefresh();
      } else {
        showSnackBarMessage(context, response.errorMessage, true);
      }
    }
  }
}
