# NotIdea

**Smart, social note-taking. Write, share, and discover.**

NotIdea is a modern mobile application that lets you create, edit, share, and discover markdown-formatted notes. Share notes with friends and groups, explore public notes from the community, and keep everything in sync across devices — even offline.

---

## Features

- **Rich Markdown Editing** — Write notes with full markdown support powered by Flutter Quill
- **Real-time Sync** — Notes are securely stored and synced via Supabase
- **Offline-first** — Read and edit notes without an internet connection (Hive local cache)
- **Share & Collaborate** — Share notes with friends, groups, or the entire public
- **Explore** — Discover publicly shared notes from the community
- **Favorites** — Bookmark notes you love
- **Groups** — Create groups and share notes with members
- **Friends System** — Add users as friends and share notes privately
- **Note Visibility** — Private, friends-only, or public per note
- **Trash & Recovery** — Deleted notes are recoverable for 30 days
- **Theming** — Light, dark, and system theme support
- **Multilingual** — English and Turkish (auto-detected from device locale)
- **Push Notifications** — Firebase Cloud Messaging for note activity
- **Crash Reporting** — Sentry integration for production monitoring
- **Secure Auth** — Supabase Auth (email/password + email verification)
- **Media Support** — Attach images to notes with automatic compression

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (`@riverpod` annotation generator) |
| Routing | GoRouter |
| Backend | Supabase (Frankfurt / fra1) |
| Database | PostgreSQL via Supabase |
| Local Storage | Hive CE (offline-first cache) |
| Data Models | Freezed + json_serializable |
| Markdown | Flutter Quill + markdown_quill |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| Push Notifications | Firebase Cloud Messaging |
| Crash Reporting | Sentry |
| Styling | Mix (utility-first) |
| Image Handling | image_picker, cached_network_image, flutter_image_compress |
| Deep Links | `notidea://` custom scheme |

---

## Project Structure

```
lib/
├── main.dart                   # Entry point (Sentry + Firebase init)
├── app.dart                    # MaterialApp.router configuration
├── config/
│   ├── env.dart                # Environment variables (flutter_dotenv)
│   └── supabase_config.dart    # Supabase client setup
├── core/
│   ├── constants/              # App-wide constants
│   ├── router/                 # GoRouter + SentryNavigatorObserver
│   ├── services/               # NotificationService (FCM)
│   ├── theme/                  # Theme, colors, ThemeExtensions
│   └── utils/                  # Helpers and extensions
├── l10n/
│   ├── app_en.arb              # English strings
│   └── app_tr.arb              # Turkish strings
├── shared/
│   ├── providers/              # Shared providers (theme, locale)
│   └── widgets/                # Shared widgets (AppScaffold, BrandedAppBar)
└── features/
    ├── auth/                   # Authentication (login, signup, password reset)
    ├── notes/                  # Notes CRUD, editor, public notes
    ├── profile/                # Profile management
    ├── friends/                # Friends system
    ├── groups/                 # Group management
    ├── explore/                # Public notes discovery
    ├── favorites/              # Favorite notes
    ├── search/                 # Note & user search
    ├── settings/               # App settings
    ├── shared_notes/           # Notes shared with user
    ├── trash/                  # Deleted notes recovery
    └── splash/                 # Splash screen
```

Each feature follows Clean Architecture:
```
feature/
├── data/
│   ├── datasources/   # Remote (Supabase) and local (Hive) sources
│   └── repositories/  # Repository implementations
├── domain/
│   ├── models/        # Freezed data models
│   └── repositories/  # Repository interfaces
└── presentation/
    ├── screens/       # UI screens
    ├── widgets/       # Feature-specific widgets
    └── providers/     # Riverpod providers
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.7`
- Dart SDK `^3.10.7`
- A Supabase project (Frankfurt / fra1 region recommended)
- A Firebase project (for push notifications)

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/notidea.git
   cd notidea
   ```

2. **Set up environment variables:**
   Create a `.env` file in the project root:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Apply Supabase migrations:**
   Run the SQL files in `supabase/migrations/` in order via the Supabase Dashboard SQL Editor.

6. **Add `google-services.json`:**
   Place your Firebase `google-services.json` in `android/app/`.

7. **Run the app:**
   ```bash
   flutter run
   ```

---

## Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com/dashboard)
   - **Region:** Frankfurt (fra1)

2. Run migration files from `supabase/migrations/` — they create tables, RLS policies, and storage buckets.

3. **Storage buckets** (created by migrations):
   - `avatars` — User profile photos
   - `note-images` — Note media

4. Copy your API keys from **Dashboard → Settings → API**:
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_ANON_KEY`

5. Set **Redirect URLs** under **Authentication → URL Configuration**:
   - Add `notidea://callback`

---

## Building

```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release
```

---

## Version

Current version: **2.0.0**

---

## License

This project is licensed under the [MIT License](LICENSE).

