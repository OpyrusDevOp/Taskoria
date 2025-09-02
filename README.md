Welcome to **Taskoria**, a gamified to-do app designed to transform task management into an engaging adventure experience. By framing tasks as quests, users earn XP, level up their profiles, and maintain streaks for consistent productivity. This README provides an overview of the project, setup instructions, design structure, and roadmap for development.

---

## Project Overview

**Taskoria** aims to motivate users to complete tasks through gamification. Tasks are categorized as different types of quests (Main, Side, Recurrent, etc.), each offering XP rewards that contribute to leveling up and unlocking ranks. The app features a red-themed UI to evoke energy and excitement, aligning with the adventurous spirit of quest completion.

- **Objective**: Create a cross-platform app for desktop and mobile devices using Flutter, focusing on user engagement through gamified task management.
- **Platform**: Built with Flutter for iOS, Android, Windows, macOS, Linux, and Web compatibility.
- **Current Status**: UI design phase complete with mock data; ready for data model and state management implementation.
- **Offline Focus**: Taskoria is designed as an offline app, using local storage for data persistence without reliance on APIs or online databases.

### Core Features

1. **Tasks as Quests**: Categorize tasks into Main Quests, Side Quests, Recurrent Quests, Challenges, Urgent Quests, and Special Events with varying XP rewards.
2. **XP and Leveling**: Earn XP for completed quests, level up, and unlock ranks from "Newcomer" to "TaskMaster".
3. **Streak System**: Track consecutive days of task completion for Recurrent Quests to encourage consistency.
4. **Profile System**: View progress with XP, level, rank, and achievements.
5. **Recurrence Options**: Set recurring tasks with customizable frequencies (Daily, Every 2-6 Days, Weekly) and starting weekdays.

### Optional Features (Planned)

- Rewards and Achievements for milestones.
- Task Difficulty settings for variable XP.
- Social Interaction for comparing progress or challenging friends (offline mode with potential future online integration).

---

## Design Structure

Taskoria's UI follows a modular structure with a consistent red theme and gamified elements. Below is an overview of the design philosophy and component organization.

### Design Philosophy

- **Gamification**: Tasks are quests, progress is shown via XP bars and badges, mimicking RPG elements.
- **Red Theme**: Primary color (#E53E3E) used for actions, highlights, and progress indicators to evoke energy.
- **Consistency**: Uniform typography, spacing (16-20px padding), and border radii (12-16px) across screens.
- **Feedback**: Interactive elements (buttons, chips) use color transitions for user feedback.
- **Responsive**: Flexible layouts with `Expanded` and `SingleChildScrollView` for different screen sizes.

### Directory Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # Theme and color definitions
├── presentation/
│   ├── pages/                      # Full screen pages
│   │   ├── onboarding_page.dart    # Introduction screen with badges
│   │   ├── home_page.dart          # Main hub with categorized quests
│   │   ├── my_task_page.dart       # Comprehensive task list with filters
│   │   ├── quest_detail_page.dart  # Detailed quest view
│   │   ├── add_quest_page.dart     # Quest creation form
│   │   ├── stats_page.dart         # Progress and analytics
│   │   └── profile_page.dart       # User info and settings
│   └── widgets/                    # Reusable UI components
│       ├── rank_badge.dart         # Gamified rank display
│       ├── profile_header.dart     # User progress header
│       ├── quest_card.dart         # Individual task card
│       ├── category_chip.dart      # Category filter chip
│       └── (other components)
└── main.dart                       # App entry point
```

### Pages Overview

1. **OnboardingPage**: Introduces the app with rank badges and a "Get Started" call-to-action.
2. **HomePage**: Central hub with profile header, category filters, and quest list; includes bottom navigation.
3. **MyTaskPage**: Comprehensive task list with status filters (All, Active, Completed) and sorting options (Due Date, Priority).
4. **QuestDetailPage**: Detailed view of a quest with subtasks and actions.
5. **AddQuestPage**: Form for creating quests with type, recurrence frequency, starting weekday, and scheduling options.
6. **StatsPage**: Visualizes progress with charts for XP, streaks, and quest types.
7. **ProfilePage**: Displays user rank, stats, achievements, and settings.

### Key Widgets

- **RankBadge**: Circular badge for ranks with gradient and glow effects.
- **ProfileHeader**: Red gradient header showing level, XP progress, and notifications.
- **QuestCard**: Task card with category, priority, due time, XP, and completion toggle.
- **CategoryChip**: Filter button for categories with red selection state.

---

## Setup Instructions

Taskoria is built with Flutter, ensuring cross-platform compatibility. Follow these steps to set up and run the project locally.

### Prerequisites

- **Flutter SDK**: Version 3.10.0 or higher.
- **Dart SDK**: Version 3.0.0 or higher.
- **IDE**: Android Studio, VS Code, or any Flutter-supported editor.
- **Device/Emulator**: For testing on mobile, desktop, or web.

### Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/OpyrusDevOp/Taskoria.git
   cd Taskoria
   ```

2. **Install Dependencies**:
   Navigate to the project directory and run:

   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Start the app on your preferred platform:

   ```bash
   flutter run
   ```

   Or specify a device:

   ```bash
   flutter run -d <device-id>
   ```

### Project Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  percent_indicator: ^4.2.3  # For progress bars
  intl: ^0.19.0             # For date formatting
```

---

## Development Roadmap

Taskoria is currently in the UI design phase. Below is the planned roadmap to complete the app as an offline application using local storage.

### Phase 1: Core Features (MVP)

- [x] UI Design for all pages (Onboarding, Home, My Task, Quest Detail, Add Quest, Stats, Profile)
- [ ] Data Models for Quests and User Profile
- [ ] Local Storage with Hive for offline data persistence
- [ ] State Management with Riverpod for quest and user data
- [ ] Basic Quest Creation and Completion functionality
- [ ] XP Calculation and Level Progression logic

### Phase 2: Gamification

- [ ] Streak System for Recurrent Quests
- [ ] Achievement System with badges
- [ ] Animated Level-Up effects
- [ ] Weekly Challenges for bonus XP

### Phase 3: Enhanced UX

- [ ] Push Notifications for due tasks and streaks (local notifications for offline use)
- [ ] Dark/Light Theme support
- [ ] Quest Categories and Advanced Filtering
- [ ] Detailed Statistics Dashboard

### Phase 4: Advanced Features

- [ ] Data Export/Import functionality for backup (offline)
- [ ] Advanced Analytics with local data processing
- [ ] Potential future online features (cloud sync, social interaction) as optional extensions

---

## Contributing

Contributions to Taskoria are welcome! If you'd like to contribute:

1. Fork the repository.
2. Create a branch for your feature or bug fix.
3. Follow the coding style and design guidelines outlined in the project.
4. Submit a pull request with a detailed description of changes.

Please ensure UI changes align with the red theme and gamified aesthetic. For functionality, prioritize modularity and testability, keeping in mind the offline nature of the app.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
