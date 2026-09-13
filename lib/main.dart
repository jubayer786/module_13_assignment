import 'package:flutter/material.dart';
import 'app.dart';
import 'data/utils/auth_utility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthUtility.getUserInfo();
  runApp(const TaskManagerApp());
}
