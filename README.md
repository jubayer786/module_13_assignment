# Module 13 Assignment - Task Manager App

Task Manager application developed with Flutter for the Ostad Module 13 assignment.

## Features
- Splash screen with custom book and pen logo
- User authentication (Sign In & Sign Up)
- 3-step Password Recovery (Email Verification, OTP/PIN Verification, Set New Password)
- Task management:
  - New Tasks
  - In Progress Tasks
  - Completed Tasks
  - Cancelled Tasks
  - Status summary count cards
  - Change task status dialog
  - Delete task with confirmation dialog
  - Add new task
- Profile update (First Name, Last Name, Mobile, Password, Profile photo)
- Persistent user session with SharedPreferences
- Full REST API integration with `https://task.teamrabbil.com/api/v1`

## Packages Used
- `http`: ^1.2.2
- `shared_preferences`: ^2.3.2
- `flutter_svg`: ^2.0.10+1
- `pin_code_fields`: ^8.0.1

## Getting Started
1. Run `flutter pub get`
2. Run `flutter run`
