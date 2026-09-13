class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String profileUpdate = '$_baseUrl/profileUpdate';
  static const String recoverResetPass = '$_baseUrl/RecoverResetPass';

  static String taskListByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static String updateTaskStatus(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTP(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
}
