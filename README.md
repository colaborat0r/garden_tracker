![Garden Tracker](assets/images/app_icon.png)

# 🌱 Garden Tracker

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

## 📲 Install on Android

No need to build from source — just download and install the latest APK directly on your Android device.

### Step 1 — Download the APK
Go to the [**Releases page**](https://github.com/colaborat0r/garden_tracker/releases/latest) and download **`GardenTracker-v1.1.0.apk`** (or the latest version listed).

### Step 2 — Allow installs from unknown sources
Because this app isn't distributed through the Play Store, Android requires you to allow installation from unknown sources:

| Android version | Steps |
|---|---|
| **Android 8+** (Oreo and above) | When you open the APK, tap **Settings** in the prompt → enable **"Allow from this source"** for your browser or file manager |
| **Android 7 and below** | Go to **Settings → Security → Unknown Sources** → toggle on |

> 💡 You can turn this setting back off after installation for security.

### Step 3 — Install
1. Open your **Downloads** folder (or tap the notification after downloading)
2. Tap **`GardenTracker-v1.1.0.apk`**
3. Tap **Install** → **Open**

### Updating
When a new version is released, simply download the new APK and install it over the existing app — your data is preserved.

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

## 🌾 Roadmap

- [x] Regional planting calendars (T&T, Zone 6–7, Zone 8, Zone 9–10)
- [x] Sample data for new users
- [x] JSON backup & restore
- [x] Photos auto-saved to device Pictures folder (Google Photos compatible)
- [ ] Home screen widget — garden summary

---


## 📜 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---

_Made with ❤️ and lots of ☀️ for homestead gardeners everywhere._
