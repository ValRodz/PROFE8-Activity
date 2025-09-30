# Flutter Todo & Habit Tracker

A comprehensive Flutter application that combines task management with habit tracking, featuring a modern Material Design 3 interface with smooth animations and responsive layouts.

## Project Structure

This project follows Flutter best practices with a clean, modular architecture:

\`\`\`
lib/
├── main.dart                 # App entry point and theme configuration
├── models/                   # Data models and business logic
│   ├── task.dart            # Task model with CRUD operations
│   └── habit.dart           # Habit model with tracking functionality
├── views/                    # Screen-level widgets (pages)
│   └── home_view.dart       # Main dashboard with navigation
├── widgets/                  # Reusable UI components
│   ├── bottom_navigation_widget.dart  # Custom navigation bar
│   ├── progress_card_widget.dart      # Reusable progress cards
│   └── quick_stats_widget.dart        # Statistics display component
└── services/                 # Business logic and data persistence
    └── storage_service.dart  # Local storage management
\`\`\`

### Why This Structure?

- **Models**: Separates data structures from UI, making the app more maintainable and testable
- **Views**: Contains screen-level widgets that represent full pages, keeping navigation logic clear
- **Widgets**: Houses reusable components that can be used across multiple screens, promoting code reuse
- **Services**: Isolates business logic and external dependencies (storage, APIs) from UI components

## Features

- ✅ **Task Management**: Create, edit, and track daily tasks
- 📈 **Habit Tracking**: Build and monitor long-term habits
- 📊 **Progress Visualization**: Interactive charts and statistics
- 🎨 **Modern UI**: Material Design 3 with custom theming
- ✨ **Smooth Animations**: Lottie animations and Flutter transitions
- 📱 **Responsive Design**: Adapts to different screen sizes
- 💾 **Local Storage**: Persistent data using shared preferences

## Dependencies

### Core Flutter Packages
- `flutter_staggered_grid_view`: Creates dynamic, Pinterest-style grid layouts for the dashboard
- `lottie`: Provides smooth, scalable animations for empty states and loading indicators
- `shimmer`: Creates skeleton loading effects for better UX
- `flutter_animate`: Adds entrance animations and micro-interactions

### Theming & Design
- `flex_color_scheme`: Advanced Material Design 3 theming with custom color palettes
- `auto_size_text`: Responsive text that adapts to available space

### Data & Storage
- `shared_preferences`: Local data persistence for tasks and habits
- `intl`: Date formatting and localization support

## Getting Started

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd flutter-todo-habit-tracker
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Run the app**
   \`\`\`bash
   flutter run
   \`\`\`

## Architecture Decisions

### State Management
- Uses `StatefulWidget` with `setState()` for local component state
- Implements service layer pattern for data persistence
- Separates UI state from business logic

### UI/UX Design
- **Material Design 3**: Leverages the latest Material Design principles with dynamic theming
- **Component-Based**: Breaks complex UIs into smaller, reusable widgets
- **Responsive Layout**: Uses flexible layouts that adapt to different screen sizes
- **Progressive Enhancement**: Adds animations and micro-interactions without compromising functionality

### Data Flow
1. **Views** handle user interactions and navigation
2. **Services** manage data persistence and business logic
3. **Models** define data structures and validation
4. **Widgets** provide reusable UI components

### Performance Optimizations
- Lazy loading with shimmer effects
- Efficient list rendering with proper keys
- Minimal rebuilds through targeted `setState()` calls
- Optimized animations using `flutter_animate`

## Widget Hierarchy

\`\`\`
MyApp (StatelessWidget)
└── MaterialApp
    └── HomeView (StatefulWidget)
        └── Scaffold
            ├── AppBar
            ├── Body
            │   ├── QuickStatsWidget
            │   └── StaggeredGrid
            │       └── ProgressCardWidget (×4)
            └── BottomNavigationWidget
\`\`\`

This hierarchy demonstrates proper separation of concerns with reusable components that can be easily maintained and tested.

## Contributing

1. Follow the established folder structure
2. Create reusable widgets in the `widgets/` directory
3. Keep business logic in `services/` and `models/`
4. Use meaningful commit messages
5. Test on multiple screen sizes

## License

This project is created for educational purposes as part of Flutter development learning objectives.
