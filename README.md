![Garden & Harvest Tracker](assets/images/app_icon.png)

# 🌱 Garden & Harvest Tracker

**The offline-first companion for homestead gardeners.**  
Track every seed, harvest, expense, and reminder — all stored privately on your device.

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-Drift_ORM-003B57?logo=sqlite&logoColor=white)](https://drift.simonbinder.eu)
[![Riverpod](https://img.shields.io/badge/State-Riverpod_2-00BCD4)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)


---

## ✨ Features

| Feature | Description |
|---|---|
| 🏡 **Dashboard** | Live stats — active plants, YTD harvest weight, YTD spend, and a recent activity feed |
| 🛏️ **Garden Beds** | Manage raised beds, containers, ground plots & hydroponics with photos |
| 🌿 **Plants** | Full plant lifecycle tracking from seed start → transplant → harvest |
| 📋 **Quick Log** | One-tap logging for observations (water, fertilize, pest check, prune) and harvests |
| ⭐ **Harvest Quality** | Rate each harvest 1–5 stars with quantity, unit, notes, and photos |
| 📊 **Reports** | Monthly harvest bar chart, expense pie chart, cost-per-lb, and plant status breakdown |
| 💸 **Expenses** | Categorised spending tracker (seeds, soil, tools, amendments) with totals |
| 🔔 **Reminders** | Task reminders with overdue alerts and one-tap complete |
| 📤 **Export** | Export all your data as JSON or share as a report |
| 🔒 **100% Offline** | No account, no cloud, no tracking — your data never leaves your device |

---

## 📸 Screenshots

> _Coming soon — run the app locally to see it in action!_

---

## 🏗️ Tech Stack

```
Flutter 3.24+  ·  Dart 3.3+  ·  Material You (Material 3)
├── 🗄️  Drift (SQLite ORM)           — offline-first local database
├── 🔄  Riverpod 2 + code generation  — reactive state management
├── 🧭  GoRouter                      — declarative navigation
├── 📈  FL Chart                      — bar & pie charts
├── 🎨  Dynamic Color                 — system-level Material You theming
├── 🖼️  Image Picker                  — photo attachments on beds, plants & logs
├── 📤  Share Plus                    — data export & sharing
└── 📄  PDF / CSV                     — report generation
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.24
- Android SDK (API 21+) for Android builds

### Run locally

```bash
# 1. Clone the repo
git clone https://github.com/your-username/garden-harvest-tracker.git
cd garden-harvest-tracker

# 2. Install dependencies
flutter pub get

# 3. Generate database & provider code
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Build a release APK

```bash
flutter build apk --release
```

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry point
├── config/
│   └── router.dart            # GoRouter route definitions
├── core/
│   ├── database/              # Drift tables, DAOs, and database class
│   ├── providers/             # Shared Riverpod providers
│   ├── theme/                 # Material 3 theme configuration
│   └── utils/                 # Formatters and helpers
└── features/
    ├── home/                  # Dashboard screen
    ├── beds/                  # Garden bed management
    ├── plants/                # Plant lifecycle screens
    ├── log/                   # Quick log (observations & harvests)
    ├── expenses/              # Expense tracker
    ├── reminders/             # Reminder system
    ├── reports/               # Analytics & charts
    ├── settings/              # App settings & data export
    └── shell/                 # Bottom navigation shell
```

---

## 🌾 Roadmap

- [ ] Widget / home screen garden summary
- [ ] Planting calendar view
- [ ] Frost date & growing zone lookup
- [ ] iCloud / Google Drive backup
- [ ] iOS support

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feat/amazing-feature`
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---

_Made with ❤️ and lots of ☀️ for homestead gardeners everywhere._
