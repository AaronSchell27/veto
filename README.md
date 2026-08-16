### Veto

Veto is a cross-platform mobile application designed to bridge the gap between voters and their government. Built using production-grade architecture, the platform empowers voters by providing transparent, easily accessible data on political candidates, political financing, and local civic engagement opportunities. 

### Core Features

* **Candidates**: Comprehensive dashboards detailing a politician's work history, voting record, and public policy stances.
* **Donors**:     Transparent breakdowns of candidates' donors, political action committees (PACs), and financial backers.
* **Events**:     A localized tracking system for citizens to find town halls, public hearings, and local government events.

### Tech Stack & Architecture

* **Frontend Framework**:    [Flutter]                  (https://flutter.dev)                   (Multi-platform UI)
* **State Management**:      [BLoC / Cubit]             (https://pub.dev/packages/flutter_bloc) (Predictable, testable business logic layer)
* **Backend-as-a-Service**:  [Supabase]                 (https://supabase.com)                  (Authentication, PostgreSQL Database, and Realtime listeners)
* **Architecture Standard**: [Very Good Ventures (VGV)] (https://verygood.ventures)             (Production-friendly standards)

### Repository Structure

Following the Very Good Ventures standard, the codebase is structured cleanly by feature layers rather than generic type folders: 
```text
lib/
├── app/                           # Global app configuration, theme, and routing
├── view/
│    └── app.dart
├── bootstrap.dart                 # Global initialization (Supabase configuration, any observers)
├── main_development.dart          # Flavor-specific entry points
├── main_production.dart
├── main_staging.dart
└── features/                      # Domain-specific feature modules
    └── candidate_profile/         # Example Feature: Candidate Dashboard
        ├── bloc/                  # Business logic layer (Events, States, Blocs)
        ├── view/                  # UI components and view pages
        ├── widgets/               # Feature-specific reusable UI components
        └── candidate_profile.dart # Barrel File
```
### Key Technical Implementation Details

* **Separation of Concerns**: UI components remain purely presentational, responding strictly to states emitted by the BLoC layer.
* **Supabase Integration**: Direct mapping of Supabase PostgreSQL tables and JSON queries into strong Dart model types via structural data repositories.
* **Enterprise Scaling**: Standardized file conventions, predictable dependency injection, and a robust CI/CD-friendly environment setup.

### Getting Started

### Prerequisites

* Flutter SDK: https://docs.flutter.dev/get-started/install (Ensure your version matches the project's SDK constraints)
* Very Good CLI: https://pub.dev/packages/very_good_cli (Optional, but recommended for VGV standard maintenance)
* Supabase Project URL: https://rttcxycxzitlwwkbtnoj.supabase.co and Anon Key: sb_publishable_FhXgMdId4X-lTiJIDtJgpw_EvyCNdaf

### Installation & Run

1. **Clone the repository**: 

  **bash**:

    git clone https://github.com/AaronSchell27/veto.git
    cd veto

2. **Get all dependencies**: 

  **bash**:

    flutter pub get

3. **Configure your local environment variables**:

  Create a .env file or provide environment definitions via --dart-define configurations for your Supabase keys.

4. **Run the application using the development flavor**: 

  **bash**:

    flutter run --flavor development -t lib/main_development.dart
