# Eventify — Complete App Explanation

A comprehensive documentation of every file, screen, widget, service, model, and package in the Eventify Event Planner application.

---

## Table of Contents

1. [Packages & Dependencies](#1-packages--dependencies)
2. [App Entry Point](#2-app-entry-point)
3. [Models](#3-models)
4. [Services](#4-services)
5. [Theme](#5-theme)
6. [Utils](#6-utils)
7. [Widgets](#7-widgets)
8. [Screens — Auth](#8-screens--auth)
9. [Screens — Attendee](#9-screens--attendee)
10. [Screens — Organizer](#10-screens--organizer)
11. [Screens — Admin](#11-screens--admin)
12. [Navigation & User Flows](#12-navigation--user-flows)
13. [Firestore Database Schema](#13-firestore-database-schema)

---

## 1. Packages & Dependencies

All packages are declared in `pubspec.yaml`:

### Core Flutter
| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | The Flutter framework itself |
| `cupertino_icons` | ^1.0.8 | iOS-style icons for cross-platform consistency |

### Firebase
| Package | Version | Purpose |
|---|---|---|
| `firebase_core` | ^3.15.0 | Required to initialize Firebase in the app. Must be called before any other Firebase service. Configured in `main.dart` via `FirebaseService.initialize()` |
| `firebase_auth` | ^5.7.0 | Handles user authentication — registration with email/password, login, logout, password change, and profile updates. Used by `FirebaseAuthService` |
| `cloud_firestore` | ^5.6.11 | NoSQL cloud database for storing events, tickets, users, and check-in records. Supports real-time streaming via `.snapshots()` for live UI updates |
| `firebase_messaging` | ^15.0.0 | Firebase Cloud Messaging (FCM) for receiving push notifications from the server. Provides device tokens and handles foreground/background message events |

### QR Code
| Package | Version | Purpose |
|---|---|---|
| `qr_flutter` | ^4.1.0 | Generates visual QR code images from string data. Used in `tickets_screen.dart` to display each ticket's unique QR code as a scannable image. The `QrImageView` widget renders the QR |
| `mobile_scanner` | ^6.0.2 | Camera-based barcode/QR code scanner. Used in `qr_scanner_screen.dart` for organizers to scan attendee QR codes at event venues. Provides the `MobileScanner` widget with real-time detection callbacks |

### Notifications
| Package | Version | Purpose |
|---|---|---|
| `flutter_local_notifications` | ^15.0.0 | Schedules and displays local notifications on the device. Used for event reminders (1 hour before) and booking confirmations. Supports both Android and iOS with platform-specific settings |
| `timezone` | ^0.9.0 | Required by `flutter_local_notifications` for scheduling notifications at specific times. Converts `DateTime` to timezone-aware `TZDateTime` objects |

### Utilities
| Package | Version | Purpose |
|---|---|---|
| `uuid` | ^4.0.0 | Generates universally unique identifiers (UUIDs v4). Used to create unique IDs for events, tickets, and QR codes. Example output: `"550e8400-e29b-41d4-a716-446655440000"` |

### Charts
| Package | Version | Purpose |
|---|---|---|
| `fl_chart` | ^0.70.2 | Charting library for Flutter. Used in `analytics_screen.dart` to render `BarChart` (tickets per event) and `PieChart` (check-in rate). Supports gradients, tooltips, and custom styling |

### Dev Dependencies
| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Flutter's built-in testing framework |
| `flutter_lints` | ^6.0.0 | Recommended lint rules for code quality. Configured in `analysis_options.yaml` |

---

## 2. App Entry Point

### `lib/main.dart`

The main entry point of the application. This file:

1. **Initializes Flutter binding** — `WidgetsFlutterBinding.ensureInitialized()` is required before any async work in `main()`
2. **Initializes Firebase** — Calls `FirebaseService.initialize()` which loads Firebase config from `firebase_options.dart`
3. **Initializes Notifications** — Calls `NotificationService.initialize()` which sets up local notifications, requests FCM token, and listens for foreground messages
4. **Runs the app** — Creates `EventifyApp`, a `StatelessWidget` that builds `MaterialApp`

**MaterialApp configuration:**
- `debugShowCheckedModeBanner: false` — Hides the debug banner
- `theme` — Sets scaffold background to `AppColors.background` (light purple `#F2F2FF`), primary color to `AppColors.primary` (purple `#6C5CE7`), centered AppBar with no elevation, and fixed bottom navigation bar styling
- `initialRoute: '/login'` — App always starts at the login screen
- **Routes map:**
  - `/login` → `LoginScreen`
  - `/register` → `RegisterScreen`
  - `/attendee` → `AttendeeMainScreen`
  - `/organizer` → `MyEventsScreen`
  - `/admin` → `AdminScreen`
  - `/add-event` → `AddEventScreen`

---

## 3. Models

### `lib/models/user_model.dart`

Defines the `UserRole` enum and `UserModel` class.

- **`UserRole` enum**: `attendee`, `organizer`, `admin` — determines which screens and features a user can access
- **`UserModel` fields**: `id`, `name`, `email`, `role` (UserRole), `createdAt` (DateTime)
- **`toJson()`** — Serializes to Map for Firestore storage. Role is stored as its `.name` string (e.g., `"attendee"`)
- **`fromJson()`** — Deserializes from Firestore Map. Uses `UserRole.values.byName()` to convert string back to enum
- **`copyWith()`** — Creates a new instance with optionally modified fields (used when changing user role)

---

### `lib/models/event_model.dart`

The core data model for events.

- **Fields**: `id`, `title`, `location`, `description`, `dateTime`, `price` (double), `creatorId`, `creatorRole` (nullable UserRole), `capacity` (default 100), `attendeeCount` (default 0), `createdAt`
- **Computed properties**:
  - `availableSeats` → `capacity - attendeeCount`
  - `isFull` → `availableSeats <= 0`
- **`toMap()`** — Serializes to Firestore-compatible Map. `dateTime` and `createdAt` are stored as Firestore Timestamps. `creatorRole` is stored as its `.name` string
- **`fromMap()`** — Deserializes from Firestore. Safely parses `creatorRole` with try/catch, uses `.toDate()` for Timestamp fields
- **`copyWith()`** — Immutable update method for all fields

---

### `lib/models/ticket_model.dart`

Represents a booked ticket linking a user to an event.

- **Fields**: `id`, `event` (embedded EventModel), `userId`, `qrCode` (unique UUID string), `purchaseDate`, `isCheckedIn` (bool, default false), `checkInTime` (nullable DateTime)
- **`toMap()`** — Flattens the embedded event into individual fields (`eventId`, `eventTitle`, `eventDateTime`, `eventLocation`, `eventPrice`) for Firestore storage
- **`fromMap()`** — Reconstructs a minimal `EventModel` from the flattened fields. Full event details can be fetched separately if needed

---

### `lib/models/checkin_model.dart`

Audit record created when an attendee checks in.

- **Fields**: `id`, `eventId`, `userId`, `qrCode`, `checkInTime`, `notes` (optional)
- **`toMap()` / `fromMap()`** — Standard Firestore serialization. `checkInTime` uses `.toDate()` for Timestamp conversion
- This model represents the Firestore `check_ins` collection schema

---

## 4. Services

### `lib/services/firebase_service.dart`

**Purpose**: One-time Firebase initialization.

- `initialize()` — Calls `Firebase.initializeApp()` with options from `DefaultFirebaseOptions.currentPlatform`
- Error handling with try/catch — the app continues running even if Firebase fails (graceful degradation)

---

### `lib/services/firebase_options.dart`

**Purpose**: Firebase project configuration.

- Contains `DefaultFirebaseOptions` class with `currentPlatform` getter
- Returns `FirebaseOptions` with API key, app ID, messaging sender ID, project ID, storage bucket, etc.
- **These are placeholder values** — must be replaced with real credentials from Firebase Console → Project Settings

---

### `lib/services/firebase_auth_service.dart`

**Purpose**: All Firebase Authentication operations.

- **`register()`** — Creates user with `createUserWithEmailAndPassword()`, then updates display name via `updateDisplayName()`
- **`login()`** — Signs in with `signInWithEmailAndPassword()`
- **`getCurrentUser()`** — Returns the Firebase `User` object (null if not logged in)
- **`getCurrentUserEmail()`** / **`getCurrentUserName()`** — Convenience getters
- **`isLoggedIn()`** — Checks if `currentUser != null`
- **`logout()`** — Calls `signOut()` on the Firebase Auth instance
- **`changePassword()`** — Re-authenticates with current password, then calls `updatePassword()`
- **`updateUserName()`** / **`updateUserPhoto()`** — Profile update methods
- Error handling catches `FirebaseAuthException` for auth-specific errors

---

### `lib/services/auth_service.dart`

**Purpose**: Local auth state management for role-based navigation.

- Stores `registeredEmail`, `registeredPassword`, `registeredRole` in static fields
- `_currentUser` — The currently logged-in `UserModel` (static, in-memory)
- **`register()`** — Saves credentials locally (used alongside Firebase for role storage)
- **`login()`** — Validates against stored credentials, creates `UserModel` with the stored role
- **`loginAdmin()`** — Creates a hardcoded admin UserModel
- **`setUserRole()`** — Changes the role of the current user
- **`logout()`** — Clears `_currentUser`
- This service works alongside `FirebaseAuthService` — Firebase handles real auth, this handles role-based routing

---

### `lib/services/event_service.dart`

**Purpose**: All Firestore CRUD operations for events.

- Uses `FirebaseFirestore.instance.collection('events')` as the data source
- **`addEvent(EventModel)`** — `doc(event.id).set(event.toMap())` — creates/updates event document
- **`getEvents()`** — One-time fetch of all events, ordered by `dateTime` ascending
- **`streamEvents()`** — Returns `Stream<List<EventModel>>` for real-time UI updates via `StreamBuilder`
- **`getEventsByCreator(creatorId)`** — Firestore query filtered by `creatorId` field
- **`streamEventsByCreator(creatorId)`** — Real-time stream version for organizer screens
- **`getEventById(eventId)`** — Single document fetch by ID
- **`deleteEventById(id)`** — `doc(id).delete()`
- **`incrementAttendeeCount(eventId)`** — Uses `FieldValue.increment(1)` for atomic counter update (prevents race conditions)

---

### `lib/services/ticket_service.dart`

**Purpose**: All Firestore CRUD operations for tickets.

- Uses `FirebaseFirestore.instance.collection('tickets')` collection
- **`addTicket(TicketModel)`** — Saves ticket to Firestore
- **`getTickets()`** — Fetches all tickets (used by admin)
- **`getTicketsByUser(userId)`** — One-time fetch filtered by userId
- **`streamTicketsByUser(userId)`** — Real-time stream for the tickets screen
- **`getTicketsByEvent(eventId)`** — Fetches tickets for a specific event (organizer analytics)
- **`getTicketByQrCode(qrCode)`** — Looks up a ticket by its QR code string (used by QR scanner for validation). Returns null if not found
- **`markCheckedIn(ticketId)`** — Updates `isCheckedIn` to true and sets `checkInTime` to current time

---

### `lib/services/qr_service.dart`

**Purpose**: QR code generation and check-in verification.

- **`generateQRCode()`** — Uses `Uuid().v4()` to create a unique string for each ticket's QR code
- **`checkIn(eventId, userId, qrCode)`** — Adds a document to the `check_ins` collection in Firestore with the check-in timestamp
- **`verifyQRCode(qrCode)`** — Queries `check_ins` to check if a QR code has already been used
- **`getCheckIns(eventId)`** — Returns all check-in records for an event (used in attendees screen)
- **`hasUserCheckedIn(eventId, userId)`** — Checks if a specific user has already checked in to an event

---

### `lib/services/notification_service.dart`

**Purpose**: Local and push notification handling.

- **`initialize()`** — Sets up:
  - Timezone data for scheduled notifications
  - Android and iOS initialization settings
  - FCM token retrieval
  - Foreground message listener (shows local notification when FCM message arrives)
- **`showNotification(title, body)`** — Immediately displays a notification with high importance/priority
- **`scheduleNotification(title, body, scheduledTime)`** — Schedules a notification for a specific datetime using `zonedSchedule()` with timezone conversion
- **`scheduleEventReminder(eventTitle, eventDateTime, hoursBefore)`** — Convenience method that subtracts hours from event time and schedules a reminder
- **`cancelNotification(id)`** / **`cancelAllNotifications()`** — Removes scheduled notifications
- Notification channels: `eventify_channel` (immediate) and `eventify_reminders_channel` (scheduled)

---

## 5. Theme

### `lib/theme/app_colors.dart`

Defines the app's color palette as static constants:

| Color | Hex | Usage |
|---|---|---|
| `primary` | `#6C5CE7` | Purple — buttons, icons, accents, AppBar, gradients |
| `secondary` | `#A86CFF` | Light purple — gradient end color, secondary accents |
| `blue` | `#4D9CFF` | Blue — used in calendar event cards |
| `dark` | `#1E1E2F` | Near-black — primary text color |
| `background` | `#F2F2FF` | Light lavender — scaffold background |
| `white` | `#FFFFFF` | White — cards, containers |

---

## 6. Utils

### `lib/utils/event_date_formatter.dart`

Provides static date/time formatting methods:

- **`formatDate(DateTime)`** — Returns `"15 May 2026"` format using month abbreviation list
- **`formatTime(DateTime)`** — Returns `"10:00 AM"` format with 12-hour conversion and padded minutes

---

## 7. Widgets

### `lib/widgets/event_card.dart`

**Reusable event card** displayed in the home screen and wherever events are listed.

- Takes `EventModel` and `VoidCallback onTap`
- **Layout**: Gradient icon box (left) → title + location (center) → price badge (right)
- **Info chips row**: Date chip, time chip, and **available seats badge**
  - Green badge with seat icon: `"X left"` when seats available
  - Red badge with block icon: `"Sold Out"` when `event.isFull`
- Wrapped in `InkWell` with rounded ripple effect
- White card with subtle box shadow

---

### `lib/widgets/role_card.dart`

**Role selection card** used in the registration screen.

- Takes `icon`, `title`, `subtitle`, `isSelected`, and `onTap`
- Shows a white card with optional purple border when selected
- Displays a check circle icon when selected
- Used to choose between "Attendee" and "Organizer" roles

---

### `lib/widgets/custom_button.dart`

**Reusable full-width button** with AppColors.primary background.

- Takes `text` and `onPressed`
- Rounded corners (18px), 60px height, white bold text
- Used as a general-purpose action button

---

### `lib/widgets/custom_textfield.dart`

**Reusable styled text field** with icon prefix.

- Takes `controller`, `hint`, `icon`, and optional `isPassword`
- White filled background, no border, rounded corners (18px)
- Icon colored with AppColors.primary

---

## 8. Screens — Auth

### `lib/screens/auth/login_screen.dart`

**User login screen** — the app's initial route.

- **UI**: Gradient logo → "Welcome Back" header → email field → password field (with visibility toggle) → Login button → Register link
- **Validation**: Checks empty email, valid email format (regex), empty password
- **Auth Flow**:
  1. Calls `FirebaseAuthService.login(email, password)`
  2. On success, fetches user role from Firestore `users` collection
  3. Sets local `AuthService` state for role tracking
  4. Routes to `/admin`, `/organizer`, or `/attendee` based on role
- **Loading state**: Shows `CircularProgressIndicator` on button during login
- **Error handling**: Shows red SnackBar on failure

---

### `lib/screens/auth/register_screen.dart`

**User registration screen** with role selection.

- **UI**: Back button → gradient logo → "Create Account" header → name/email/password/confirm fields → role cards (Attendee/Organizer) → Create Account button → Login link
- **Validation**: Name not empty, email format, password ≥ 6 chars, passwords match
- **Auth Flow**:
  1. Calls `FirebaseAuthService.register(email, password, name, role)`
  2. Saves user profile to Firestore `users` collection (id, name, email, role, createdAt)
  3. Also registers locally in `AuthService` for role tracking
  4. Navigates to `/login` on success
- **Loading state**: Spinner on button, disabled during registration
- **Error handling**: Shows error for duplicate emails, network issues, etc.

---

## 9. Screens — Attendee

### `lib/screens/attendee/attendee_main_screen.dart`

**Bottom navigation container** for the attendee experience.

- **Tabs**: Home, Calendar, Tickets, Settings
- Manages `currentIndex` state to switch between screens
- Uses `IndexedStack` (via direct screen access) — screens are `HomeScreen`, `CalendarScreen`, `TicketsScreen`, `SettingsScreen`

---

### `lib/screens/attendee/home_screen.dart`

**Event discovery screen** — the main landing page for attendees.

- **StatefulWidget** with `StreamBuilder<List<EventModel>>`
- Streams all events from Firestore in real-time via `EventService.streamEvents()`
- Shows loading spinner while connecting
- **UI**: "Welcome Back 👋" → search bar → "Upcoming Events" header → list of `EventCard` widgets
- Tapping an event card navigates to `EventDetailsScreen`
- Shows empty state with icon when no events exist

---

### `lib/screens/attendee/event_details_screen.dart`

**Full event details and booking screen**.

- **StatefulWidget** managing booking state and event data refresh
- **UI sections**:
  - Gradient header with event icon and back button
  - Title, date, location, time rows with icons
  - **Available seats indicator** — green/red coloring, shows "X / Y seats available" or "Sold Out"
  - "About Event" description section
  - Price card with "Book Now" / "Sold Out" button
- **Booking flow**:
  1. Checks `event.isFull` — disables button if sold out
  2. Creates `TicketModel` with UUID id and unique QR code
  3. Saves ticket to Firestore via `TicketService.addTicket()`
  4. Increments `attendeeCount` via `EventService.incrementAttendeeCount()`
  5. Schedules 1-hour reminder via `NotificationService.scheduleEventReminder()`
  6. Shows immediate confirmation notification
  7. Refreshes event data to display updated seat count
- **Loading state**: Spinner on button during async booking

---

### `lib/screens/attendee/tickets_screen.dart`

**User's booked tickets with QR codes**.

- **StatefulWidget** with `StreamBuilder` on `TicketService.streamTicketsByUser(userId)`
- Gets `userId` from `FirebaseAuthService.getCurrentUser()?.uid`
- **Ticket card design**: Gradient purple card with event name, date, location, time, price → divider → ticket status + **real QR code**
- **QR code display**: Uses `QrImageView` from `qr_flutter` package with `ticket.qrCode` data, 70px size, white background
- **Tap-to-expand**: Tapping QR opens a dialog with 220px QR code, event title, ticket ID, and "Show this QR code at the venue" instruction
- **Check-in status**: Shows "Checked In ✓" or "Confirmed" based on `ticket.isCheckedIn`
- Empty state: "No Tickets Booked Yet 🎟"

---

### `lib/screens/attendee/calendar_screen.dart`

**Interactive calendar with event indicators**.

- **StatefulWidget** that loads all events and user's tickets from Firestore
- **Dynamic month navigation**: Left/right arrows change month, month name updates dynamically
- **Calendar grid**: Proper weekday alignment using `_firstDayOfWeek()`, shows all days of current month
- **Event dot indicators**: Small colored dot under days that have events
- **Day selection**: Tap a day to see events on that date
- **Event cards below calendar**: Shows all events on the selected day with title, time, location
- **"Booked" badge**: Green badge appears on events the user has tickets for
- No hardcoded data — all dates, months, and events are computed dynamically

---

### `lib/screens/attendee/settings_screen.dart`

**User profile and app settings**.

- **Profile card**: Shows user's real name, email (from `FirebaseAuthService.getCurrentUser()`), and role badge
- Falls back to `AuthService.currentUser` if Firebase user data unavailable
- **Settings items**: Dark Mode, Notifications, Language, Privacy (UI placeholders for future features)
- **About items**: About Eventify, Help & Support
- **Logout**: Calls both `FirebaseAuthService.logout()` and `AuthService.logout()`, then navigates to `/login` clearing the navigation stack

---

## 10. Screens — Organizer

### `lib/screens/organizer/my_events_screen.dart`

**Organizer's main hub** with bottom navigation.

- **Tabs**: My Events, Add Event (opens modal), Attendees, Analytics
- **My Events tab**: StreamBuilder with `EventService.streamEventsByCreator(creatorId)`
  - Gradient header: "Manage Your Events"
  - Stat cards: Events count, Tickets count (summed from `attendeeCount` of all events)
  - Event list with title, location, date, attendee/capacity count, delete button
  - Empty state when no events created
- Add Event tab opens `AddEventScreen` via `Navigator.pushNamed`

---

### `lib/screens/organizer/add_event_screen.dart`

**Event creation form**.

- **Fields**: Title, Location, Description (multiline), Date (date picker), Time (time picker), Price, **Capacity** (default 100)
- Date picker: `showDatePicker()` with range from today to 2035
- Time picker: `showTimePicker()` with AM/PM display
- **Validation**: Requires date and time to be selected before submission
- **Save flow**: Creates `EventModel` with timestamp ID, saves to Firestore via `await EventService.addEvent()`
- Loading spinner on button during save
- Navigates back on success

---

### `lib/screens/organizer/attendees_screen.dart`

**Check-in management with QR scanner integration**.

- **StatefulWidget** that loads organizer's events and check-in data
- **Event selector dropdown**: Pick which event's attendees to view
- **Stats row**: "Registered" count (from `event.attendeeCount`) and "Checked In" count (from Firestore check_ins)
- **Checked-in attendees list**: Shows user ID (truncated), check-in timestamp, green verified icon
- **"Scan QR" FAB**: Opens `QRScannerScreen` with the selected event's ID. Refreshes check-in data when returning
- Empty state when no check-ins yet

---

### `lib/screens/organizer/qr_scanner_screen.dart`

**Camera-based QR code scanner**.

- Uses `MobileScanner` widget from `mobile_scanner` package
- **Scan overlay**: Centered frame that changes color (purple = scanning, green = success, red = error)
- **AppBar controls**: Flash/torch toggle, camera flip button
- **Detection flow**:
  1. `_onBarcodeDetected()` called when camera detects a barcode
  2. Prevents duplicate processing with `_isProcessing` flag
  3. Looks up ticket via `TicketService.getTicketByQrCode(qrCode)`
  4. Validates: ticket exists? already checked in? correct event?
  5. On success: calls `QRService.checkIn()` and `TicketService.markCheckedIn()`
  6. Shows result overlay (green success or red error) for 3 seconds
  7. Auto-resets for continuous scanning
- **Result overlay**: Large icon + message text with colored background and shadow

---

### `lib/screens/organizer/analytics_screen.dart`

**Statistics dashboard with charts**.

- **StatefulWidget** that loads analytics data from Firestore on init
- **Data fetching**: For each of the organizer's events, fetches tickets (via `TicketService.getTicketsByEvent()`) and check-ins (via `QRService.getCheckIns()`)
- **Stat cards**: Total events, total tickets, total check-ins, total revenue (calculated as tickets × price)
- **Bar chart** (`fl_chart` `BarChart`): Tickets sold per event with purple gradient bars, tooltips showing event name and count, truncated x-axis labels
- **Pie chart** (`fl_chart` `PieChart`): Check-in rate — green sector (checked in %) vs grey sector (not yet %). Includes legend with counts
- Empty state: "No data yet — Charts will appear once tickets are sold"

---

## 11. Screens — Admin

### `lib/screens/admin/admin_screen.dart`

**Full admin dashboard** with system-wide visibility.

- **Bottom navigation tabs**: Dashboard, Events, System Event (opens add screen), Admin
- **Dashboard tab** (`StreamBuilder` on all events + `FutureBuilder` for ticket count):
  - Gradient "Welcome Admin" card
  - Statistics grid: Events, Tickets, Attendees (sum of all event attendeeCounts), Revenue (computed from tickets × price)
  - Recent events list (top 3) with delete buttons
- **Events tab**: Full list of all events in the system with creator labels ("System event" vs "Organizer event"), attendee/capacity count, delete buttons
- **System Event tab**: Opens `AddEventScreen` via navigation
- **Admin tab**: Admin panel info card, logout button
- All delete operations are async Firestore calls

---

## 12. Navigation & User Flows

### Route Map

```
/login          → LoginScreen
/register       → RegisterScreen
/attendee       → AttendeeMainScreen (tabs: Home, Calendar, Tickets, Settings)
/organizer      → MyEventsScreen (tabs: My Events, Add Event, Attendees, Analytics)
/admin          → AdminScreen (tabs: Dashboard, Events, System Event, Admin)
/add-event      → AddEventScreen
```

### Attendee Flow
```
Login → /attendee → HomeScreen
                  ↓ tap event card
               EventDetailsScreen → "Book Now" → ticket saved + notification scheduled
                  ↑ back
               HomeScreen → tab: Tickets → TicketsScreen (view QR)
                          → tab: Calendar → CalendarScreen (view schedule)
                          → tab: Settings → SettingsScreen → Logout → /login
```

### Organizer Flow
```
Login → /organizer → MyEventsScreen (My Events tab)
                   → tab: Add Event → /add-event → AddEventScreen → event saved → back
                   → tab: Attendees → AttendeesScreen → "Scan QR" → QRScannerScreen
                   → tab: Analytics → AnalyticsScreen (charts)
                   → AppBar: Logout → /login
```

### Admin Flow
```
Login → /admin → AdminScreen (Dashboard tab — stats)
              → tab: Events (all events — delete)
              → tab: System Event → /add-event → event saved → back
              → tab: Admin → Logout → /login
```

---

## 13. Firestore Database Schema

### `users` Collection
```
users/{userId}
├── id: string (Firebase UID)
├── name: string
├── email: string
├── role: string ("attendee" | "organizer" | "admin")
└── createdAt: string (ISO 8601)
```

### `events` Collection
```
events/{eventId}
├── id: string (timestamp-based)
├── title: string
├── location: string
├── description: string
├── dateTime: timestamp
├── price: number
├── creatorId: string (userId of creator)
├── creatorRole: string ("admin" | "organizer" | null)
├── capacity: number (default 100)
├── attendeeCount: number (incremented on booking)
└── createdAt: timestamp
```

### `tickets` Collection
```
tickets/{ticketId}
├── id: string (UUID v4)
├── eventId: string
├── eventTitle: string
├── eventDateTime: timestamp
├── eventLocation: string
├── eventPrice: number
├── userId: string (buyer's Firebase UID)
├── qrCode: string (UUID v4 — unique per ticket)
├── purchaseDate: timestamp
├── isCheckedIn: boolean (default false)
└── checkInTime: timestamp (null until checked in)
```

### `check_ins` Collection
```
check_ins/{auto-id}
├── eventId: string
├── userId: string
├── qrCode: string
└── checkInTime: timestamp
```

---

*This document covers every file, class, method, package, and data flow in the Eventify application.*
