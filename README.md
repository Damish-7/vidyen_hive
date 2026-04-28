# VIDYEN — Conference Management App

> **Knowledge. Excellence. Together.**

A full-featured Flutter conference portal built with **GetX** for state management and **Hive** for local offline storage. Designed for two user roles — **Admin** and **Participant** — with a responsive layout that adapts across mobile, tablet, and desktop.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Default Credentials](#default-credentials)
- [Architecture](#architecture)
- [Models](#models)
- [Screens](#screens)
- [Responsive Design](#responsive-design)
- [State Management](#state-management)
- [Hive Storage](#hive-storage)
- [Dependencies](#dependencies)
- [Build & Run](#build--run)

---

## Overview

VIDYEN is a conference management portal that allows participants to register, submit abstracts, pre-conference sessions, and workshop registrations. Admins can review all submissions, approve or reject them with remarks, manage participants, and issue certificates.

All data is stored **locally on-device** using Hive — no backend or internet connection required.

---

## Features

### Participant (End-User)
- Register with full professional profile
- Secure login with SHA-256 password hashing
- Submit **Abstracts** with title, description, category, co-authors, keywords, and file attachment
- Submit **Pre-Conference** session registrations
- Submit **Workshop** registrations
- View submission status (Pending / Approved / Rejected)
- View admin remarks on each submission
- View issued **Certificates**
- Full **Profile** page with registration details
- Persistent login session across app restarts

### Admin
- Dedicated admin portal with gold-themed UI
- **Dashboard** with 8 live stats cards (total users, approved, pending, abstracts, pre-conf, workshops, certificates, pending reviews)
- **User Management** — search, filter by status, view full details, approve or reject participants
- **Abstract Review** — view all submissions, filter by status, tap to review, set approve/reject/pending decision, add remarks
- **Pre-Conference Review** — same review flow as abstracts
- **Certificate Issuance** — issue certificates to approved participants with custom title and type
- View all issued certificates in a list/grid

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State Management | GetX 4.6 |
| Local Database | Hive 2.2 + Hive Flutter |
| Password Hashing | crypto (SHA-256) |
| Fonts | Google Fonts (Playfair Display + Inter) |
| File Picker | file_picker |
| ID Generation | uuid |
| Routing | GetX Named Routes |

---

## Project Structure

```
vidyen_hive/
│
├── pubspec.yaml
├── README.md
├── assets/
│   └── images/
│
└── lib/
    ├── main.dart                        # App entry, GetX bindings, routes
    │
    ├── controllers/
    │   ├── auth_controller.dart         # Login, register, session, logout
    │   └── submission_controller.dart   # CRUD for submissions & certificates
    │
    ├── models/
    │   ├── user_model.dart              # Hive model — participant/admin
    │   ├── user_model.g.dart            # Generated Hive adapter
    │   ├── submission_model.dart        # Hive model — abstract/preconf/workshop
    │   ├── submission_model.g.dart      # Generated Hive adapter
    │   ├── certificate_model.dart       # Hive model — issued certificate
    │   └── certificate_model.g.dart     # Generated Hive adapter
    │
    ├── services/
    │   └── hive_service.dart            # All Hive box operations + admin seed
    │
    ├── utils/
    │   ├── app_theme.dart               # Colors, ThemeData, AppConstants
    │   └── responsive.dart              # Responsive breakpoints & sizing helpers
    │
    ├── widgets/
    │   └── common_widgets.dart          # StatusBadge, SubmissionCard,
    │                                    # GradientButton, SectionHeader, StatCard
    │
    └── screens/
        ├── splash_screen.dart           # Animated splash with auto-navigation
        ├── login_screen.dart            # Email/password login
        ├── register_screen.dart         # 2-step registration form
        ├── home_screen.dart             # User home with bottom nav / rail
        ├── profile_screen.dart          # Participant profile details
        │
        ├── dashboard/
        │   ├── dashboard_home_tab.dart  # Welcome banner, stats, quick actions
        │   ├── abstract_screen.dart     # User abstract list + submit
        │   ├── preconf_screen.dart      # User pre-conf list + submit
        │   ├── workshop_screen.dart     # User workshop list + submit
        │   ├── certificate_screen.dart  # User certificates list
        │   └── submission_form_sheet.dart # Reusable bottom sheet form
        │
        └── admin/
            ├── admin_home_screen.dart   # Admin shell with nav rail / bottom bar
            ├── admin_dashboard_tab.dart # Stats overview
            ├── admin_users_tab.dart     # User list, search, filter, approve/reject
            ├── admin_submissions_tab.dart # Review submissions (abstract & preconf)
            └── admin_certificates_tab.dart # Issue & view certificates
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code with Flutter extension

### Installation

```bash
# 1. Clone or download the project
git clone <your-repo-url>
cd vidyen_hive

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> **Note:** The `.g.dart` Hive adapter files are already included in the project. You do **not** need to run `build_runner`. If you modify any `@HiveType` model, regenerate with:
> ```bash
> flutter pub run build_runner build --delete-conflicting-outputs
> ```

---

## Default Credentials

The app automatically seeds an admin account on first launch.

| Role | Email | Password |
|---|---|---|
| Admin | admin@vidyen.org | Admin@123 |
| User | Register a new account | Your chosen password |

---

## Architecture

```
UI (Screens)
    │
    ▼
Controllers (GetX — Reactive)
    │
    ▼
Services (HiveService — Business Logic)
    │
    ▼
Hive Boxes (Local On-Device Storage)
```

- **Screens** call controller methods and observe reactive state via `Obx()`
- **Controllers** contain all business logic and call `HiveService` for data operations
- **HiveService** is a static utility class that wraps all Hive box reads and writes
- **Session** persistence is handled via a dedicated `session` Hive box that stores the current user ID

---

## Models

### UserModel (`typeId: 0`)

| Field | Type | Description |
|---|---|---|
| id | String | UUID v4 |
| name | String | Full name |
| email | String | Login email |
| passwordHash | String | SHA-256 hashed password |
| regCode | String | Auto-generated registration code (e.g. VID-2025-AB1C2D) |
| delegateType | String | Speaker / Delegate / Presenter etc. |
| designation | String | Job title |
| institution | String | Organisation name |
| city | String | City |
| country | String | Country |
| phone | String | Phone number |
| status | String | `pending` / `approved` / `rejected` |
| isAdmin | bool | Admin flag |
| createdAt | DateTime | Registration timestamp |

### SubmissionModel (`typeId: 1`)

| Field | Type | Description |
|---|---|---|
| id | String | UUID v4 |
| userId | String | Owner user ID |
| userName | String | Submitter name (denormalised) |
| type | String | `abstract` / `preconf` / `workshop` |
| title | String | Submission title |
| description | String | Abstract / description text |
| filePath | String? | Path of attached file |
| status | String | `pending` / `approved` / `rejected` |
| adminRemark | String? | Admin feedback |
| submittedAt | DateTime | Submission timestamp |
| coAuthors | String? | Comma-separated co-author names |
| keywords | String? | Comma-separated keywords |
| category | String? | Selected category |

### CertificateModel (`typeId: 2`)

| Field | Type | Description |
|---|---|---|
| id | String | UUID v4 |
| userId | String | Recipient user ID |
| userName | String | Recipient name |
| title | String | Certificate title |
| type | String | Participation / Presentation / Workshop etc. |
| issuedAt | DateTime | Issue timestamp |
| issuedBy | String | Issuing admin name |
| filePath | String? | Optional file path |

---

## Screens

### Auth Flow
| Screen | Description |
|---|---|
| `SplashScreen` | Animated logo with auto-redirect based on saved session |
| `LoginScreen` | Email + password login with form validation |
| `RegisterScreen` | 2-step form — Step 1: personal info, Step 2: professional details |

### User Flow
| Screen | Description |
|---|---|
| `HomeScreen` | Shell with bottom nav (mobile) or navigation rail (tablet/desktop) |
| `DashboardHomeTab` | Welcome banner, stat cards, quick action grid, info section |
| `AbstractScreen` | List of user's abstract submissions + FAB to open submit form |
| `PreconfScreen` | List of user's pre-conference submissions + FAB |
| `WorkshopScreen` | List of user's workshop registrations + FAB |
| `CertificateScreen` | List/grid of certificates issued to the user |
| `ProfileScreen` | Full participant profile with all registration fields |
| `SubmissionFormSheet` | Reusable bottom sheet: title, description, category, co-authors, keywords, file |

### Admin Flow
| Screen | Description |
|---|---|
| `AdminHomeScreen` | Admin shell with gold-accented nav rail / bottom bar |
| `AdminDashboardTab` | 8-card stats overview grid |
| `AdminUsersTab` | Searchable, filterable user list; approve/reject/view details |
| `AdminSubmissionsTab` | Filterable submission list; tap to open review dialog with decision + remarks |
| `AdminCertificatesTab` | Issue new certificates; view all issued certificates |

---

## Responsive Design

The app uses a custom `Responsive` utility class (`lib/utils/responsive.dart`) for all sizing and layout decisions.

### Breakpoints

| Name | Width |
|---|---|
| Mobile | < 600px |
| Tablet | 600px – 1023px |
| Desktop | ≥ 1024px |

### Adaptive Layouts

| Element | Mobile | Tablet | Desktop |
|---|---|---|---|
| Navigation | Bottom nav bar | Navigation Rail (icons) | Extended Rail (icons + labels) |
| Content max width | Full width | 700px | 900px |
| Stat grid | 4 cols | 4 cols | 4 cols |
| Quick actions | 2×2 | 4 in a row | 4 in a row |
| User list (admin) | List | 2-col grid | 3-col grid |
| Submission list (admin) | List | 2-col grid | 3-col grid |
| Certificates | List | 2-col grid | 3-col grid |
| Profile details | Stacked | 2-col side by side | 2-col side by side |
| Register form | Stacked | 2-col fields | 2-col fields |
| Submit form sheet | Stacked | 2-col fields | 2-col fields |

### Responsive Helpers

```dart
Responsive.init(context);          // Must call in every build()
Responsive.isMobile                // bool
Responsive.isTablet                // bool
Responsive.isDesktop               // bool
Responsive.font(14)                // Scaled font size
Responsive.sp(16)                  // Scaled spacing/padding
Responsive.icon(20)                // Scaled icon size
Responsive.w(50)                   // 50% of screen width
Responsive.h(10)                   // 10% of screen height
Responsive.pageHPad()              // Horizontal page padding value
Responsive.maxContentWidth         // Max content width constraint
Responsive.gridCrossAxisCount(     // Adaptive grid columns
  mobile: 2, tablet: 3, desktop: 4
)
```

---

## State Management

GetX is used throughout with **permanent** controller binding.

```dart
// AppBindings registered in main.dart
Get.put<AuthController>(AuthController(), permanent: true);
Get.put<SubmissionController>(SubmissionController(), permanent: true);
```

### AuthController
- `currentUser` — `Rx<UserModel?>` observed by all screens
- `isLoading` — `RxBool` for button loading states
- `login()`, `register()`, `logout()`
- Auto-restores session from Hive on `onInit()`

### SubmissionController
- Separate lists for user and admin views: `abstracts`, `preconfs`, `workshops`, `certificates`, `allAbstracts`, `allPreconfs`, `allWorkshops`, `allCertificates`
- `loadAll()` — refreshes all lists from Hive
- `submitAbstract()`, `submitPreconf()`, `submitWorkshop()`
- `updateStatus()` — admin approve/reject with remark
- `issueCertificate()` — admin certificate issuance

---

## Hive Storage

Three typed boxes + one dynamic session box:

| Box Name | Type | Content |
|---|---|---|
| `users` | `Box<UserModel>` | All registered users |
| `submissions` | `Box<SubmissionModel>` | All submissions |
| `certificates` | `Box<CertificateModel>` | All issued certificates |
| `session` | `Box` | Current user ID for persistent login |

### Password Security

Passwords are **never stored in plain text**. Before saving, passwords are hashed using SHA-256 via the `crypto` package:

```dart
static String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

### Admin Seeding

On first launch, `HiveService.init()` automatically creates the default admin account if no admin exists in the users box.

---

## Dependencies

```yaml
dependencies:
  get: ^4.6.6              # State management & routing
  hive: ^2.2.3             # Local NoSQL database
  hive_flutter: ^1.1.0     # Hive Flutter integration
  crypto: ^3.0.3           # SHA-256 password hashing
  google_fonts: ^6.1.0     # Playfair Display + Inter fonts
  flutter_animate: ^4.3.0  # Animations
  cached_network_image: ^3.3.0
  intl: ^0.18.1            # Date formatting
  file_picker: ^6.1.1      # File attachment picker
  uuid: ^4.2.1             # UUID generation
  path_provider: ^2.1.1    # File system paths
  flutter_svg: ^2.0.9      # SVG support

dev_dependencies:
  hive_generator: ^2.0.1   # Hive adapter codegen
  build_runner: ^2.4.7     # Code generation runner
  flutter_lints: ^3.0.0    # Linting rules
```

---

## Build & Run

### Debug
```bash
flutter run
```

### Release APK
```bash
flutter build apk --release
```

### Release AAB (Play Store)
```bash
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```

### Desktop (Windows / macOS / Linux)
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## Color Palette

| Name | Hex | Usage |
|---|---|---|
| Primary | `#0A1628` | Background |
| Surface | `#0F2040` | AppBar, nav |
| Card BG | `#162848` | Cards |
| Accent | `#1E6FD9` | Primary actions, buttons |
| Accent Light | `#4A9FFF` | Text links, highlights |
| Gold | `#D4A843` | Admin theme, badges |
| Gold Light | `#F0C96A` | Admin text |
| Success | `#2ECC71` | Approved status |
| Warning | `#F39C12` | Pending status |
| Error | `#E74C3C` | Rejected status |

---

## Notes

- All data is stored **locally on-device** — no network calls are made by the app itself
- The `.g.dart` adapter files are pre-generated; `build_runner` is only needed if models are modified
- File picker stores the file path reference only; actual file content is not copied into Hive
- The admin account cannot be created through the register flow — it is seeded automatically
- Session persists across cold restarts; logout clears the session box

---

*Built with Flutter · GetX · Hive*

~~ Damish-7