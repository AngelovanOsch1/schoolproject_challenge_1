import 'package:challenge_one_project/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Set window properties
  windowManager.waitUntilReadyToShow().then((_) async {
    // Set window properties to disable resizing, minimizing, maximizing, etc.
    await windowManager.setResizable(false); // Disable resizing
    await windowManager.setMaximizable(false); // Disable maximizing
    await windowManager.setMinimizable(false); // Disable minimizing
    await windowManager.setFullScreen(false); // Prevent fullscreen
    await windowManager.setAlwaysOnTop(false); // Ensure it's not forced on top

    // Remove the title bar (makes the window frameless)
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);

    // Apply rounded corners (only works on Windows 11)
    await windowManager.setBounds(await windowManager.getBounds()); // Forces refresh to apply rounding
    await windowManager.setHasShadow(true); // Adds shadow effect
    await windowManager.setAspectRatio(16 / 9); // Optional: Keep aspect ratio

    // Center the window
    await windowManager.center(); // Center the window on the screen

    await windowManager.show();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const  LoginScreen(),
    );
  }
}

// Helper method to build a single input column
Widget buildInputColumn(String text, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    ],
  );
}

// Helper method to build a row of two input columns
Widget buildInputRow(String text, String text2, TextEditingController controller) {
  return Row(
    children: [
      Expanded(child: buildInputColumn(text, controller)),
      const SizedBox(width: 20), // Spacing between the columns
      Expanded(child: buildInputColumn(text2, controller)),
    ],
  );
}
