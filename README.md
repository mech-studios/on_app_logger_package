# on_app_logger_package

A lightweight **in-app logging overlay** for Flutter applications — ideal for debugging and viewing runtime logs **directly inside your app’s UI**, without needing the console.

It features:
- **Real-time log updates**  
- **Toggleable small or full-screen log viewers**  
- **Clickable and selectable links in logs**  
- **Works out of the box — just wrap your app with one line of code**

---

## Installation

Add the dependency to your **pubspec.yaml**:

```yaml
dependencies:
  on_app_logger_package: latest_version
```

```bash
flutter pub get
```

---

## Basic Usage

put the `AppLoggerWrapper` widget in the builder paramter of your `MaterialApp` or `CupertinoApp`.

```dart
import 'package:flutter/material.dart';
import 'package:on_app_logger_package/on_app_logger_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Wrap the app with the logger
        return AppLoggerWrapper(child: child!);
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}
```

---

## 🧾 Logging Messages

You can log messages from **anywhere in your app** using:

```dart
AppLoggerWrapper.log("This is a log message!");
```

Example with dynamic values and URLs:
```dart
int counter = 3;
AppLoggerWrapper.log("Button pressed $counter times — visit google.com");
```

This will automatically appear in the in-app log viewer.
URLs are highlighted and clickable.

---

## Log Viewer Controls

At the top of the screen (only in debug mode by default), you’ll see two buttons:
- **Full Log Page** → Expands the logger to a full-screen view
- **Toggle Small Log** Reader → Opens a floating overlay window

You can view, scroll, and interact with your logs live.

---

## Configuration
| Parameter | Type | Default | Description |
|:------------:|:-------------:|:-------------:|:-------------:|
| isEnabled | bool | kDebugMode | Wheather to enable the log overlay |
| child | Widget | -- | Your app's root widget |

Example of forcing logs to show in release mode:

```dart
AppLoggerWrapper(
  isEnabled: true, // Force enable in release
  child: child!,
)
```

---

## Tips

- Works best for **debug builds** and **QA testing**
- Combine with your app’s analytics or internal log systems if needed
- Log messages persist **only during the current session**

---

## Example Output

When pressing a button and logging:
```dart
AppLoggerWrapper.log("Hi 1 google.com");
```
You’ll see in the overlay:
```text
Log: Hi 1 google.com
```
`google.com` is highlighted and tappable.
