# Lush List: A Modern Animated To-Do App

Lush List is a beautifully designed, production-ready nested to-do list application built with Flutter. It goes beyond standard to-do apps by incorporating fluid animations and intelligent task management logic, offering a truly delightful user experience.


## Core Features

*   **Infinitely Nested Tasks:** Create tasks and sub-tasks to any depth, perfect for breaking down complex projects.
*   **Topic Organization:** Group your to-do lists into clear, manageable topics.
*   **Intelligent Auto-Completion:** Parent tasks automatically complete when all their sub-tasks are done, and un-complete if a new sub-task is added.
*   **Leaf-Node Progress Tracking:** Progress bars are calculated based on the completion of the most deeply nested tasks, giving a true sense of progress.
*   **Fluid & Modern UI:** A clean, elegant interface that is a pleasure to use.
*   **Local Data Persistence:** Your tasks are saved securely on your device, available anytime.

## Our Unique Selling Proposition: The Animations

What sets Lush List apart is its "juice"—the collection of modern, meaningful animations that make the app feel alive and responsive.

*   **Seamless Transitions:** Smooth slide animations guide the user between the topic and task detail screens.
*   **Staggered List Entrances:** Items animate into view sequentially, creating a dynamic and engaging flow.
*   **Micro-interactions:** Small, satisfying animations like a "shake" on task completion provide delightful feedback.
*   **Dynamic UI Elements:** Counters and progress bars animate their state changes, making the interface feel responsive and connected to your actions.

## Tech Stack & Architecture

*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** Provider
*   **Animations:** flutter_animate
*   **Local Storage:** shared_preferences
*   **Architecture:** Feature-first directory structure, separating UI from business logic for maintainability.

## Project Structure

The project follows a clean, feature-driven structure to keep the codebase scalable and easy to navigate.

```
lib/
├── main.dart
├── app/
│   ├── models/         # Data models (TodoItem)
│   ├── providers/      # State management (TodoProvider)
│   ├── services/       # Backend services (LocalStorageService)
│   └── views/          # UI Screens (HomeScreen, TodoListScreen)
└── utils/              # Shared utilities (AppColors, AppTheme)
```

## Getting Started

To run this project locally, follow these simple steps.

**1. Clone the repository:**

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

**2. Install dependencies:**

Ensure you have the Flutter SDK installed. Then, run the following command in the project root to fetch all the necessary packages.

```bash
flutter pub get
```

**3. Run the application:**

Connect a device or start an emulator, then run the app.

```bash
flutter run
```
