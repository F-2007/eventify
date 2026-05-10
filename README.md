# Eventify — Event Planner App 🎉

A feature-rich **Event Planner** mobile application built with **Flutter** and **Firebase Firestore**. Eventify enables attendees to discover and book events, organizers to create and manage events with QR check-in, and admins to oversee the entire platform.

---

## Features

### 🎟 Event Management
- Create, view, and delete events with rich detail cards
- Real-time event updates using Firestore streams
- Capacity tracking with available seats display
- Event search and calendar integration

### 📱 QR Code Check-In System
- Unique QR code generated for every ticket
- Visual QR display on ticket cards (tap to expand)
- Camera-based QR scanner for organizers
- Real-time check-in validation and duplicate detection

### 🔔 Push Notifications
- Local notification reminders (1 hour before event)
- Instant booking confirmation notifications
- Firebase Cloud Messaging (FCM) support for push notifications

### 👥 Role-Based Access
- **Attendee**: Browse events, book tickets, view QR codes, manage schedule
- **Organizer**: Create events, scan QR codes, view attendees, analytics dashboard
- **Admin**: Full platform overview, manage all events, system statistics

### 📊 Analytics Dashboard
- Bar charts showing tickets sold per event
- Pie charts showing check-in rates
- Real-time revenue, ticket, and attendee statistics

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform mobile UI framework |
| **Firebase Auth** | User authentication (email/password) |
| **Cloud Firestore** | Real-time NoSQL database |
| **Firebase Messaging** | Push notifications (FCM) |
| **qr_flutter** | QR code generation and display |
| **mobile_scanner** | Camera-based QR code scanning |
| **fl_chart** | Bar and pie chart visualizations |
| **flutter_local_notifications** | Scheduled local notifications |
| **uuid** | Unique ID generation for tickets/events |
| **timezone** | Timezone-aware notification scheduling |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point, Firebase & notification init
├── models/
│   ├── event_model.dart               # Event data model with Firestore serialization
│   ├── ticket_model.dart              # Ticket data model with QR code field
│   ├── checkin_model.dart             # Check-in record model
│   └── user_model.dart               # User model with role enum
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart          # Firebase Auth login with validation
│   │   └── register_screen.dart       # Registration with role selection
│   ├── attendee/
│   │   ├── attendee_main_screen.dart  # Bottom nav container for attendee tabs
│   │   ├── home_screen.dart           # Event discovery with real-time streaming
│   │   ├── event_details_screen.dart  # Event details, booking, capacity check
│   │   ├── tickets_screen.dart        # User's tickets with QR codes
│   │   ├── calendar_screen.dart       # Dynamic calendar with event indicators
│   │   └── settings_screen.dart       # User profile and settings
│   ├── organizer/
│   │   ├── my_events_screen.dart      # Organizer's event management hub
│   │   ├── add_event_screen.dart      # Event creation form with capacity
│   │   ├── attendees_screen.dart      # Check-in management with QR scanner
│   │   ├── analytics_screen.dart      # Charts and statistics dashboard
│   │   └── qr_scanner_screen.dart     # Camera QR code scanner
│   └── admin/
│       └── admin_screen.dart          # Admin dashboard with system stats
├── services/
│   ├── firebase_service.dart          # Firebase initialization
│   ├── firebase_options.dart          # Firebase project configuration
│   ├── firebase_auth_service.dart     # Firebase Auth operations
│   ├── auth_service.dart              # Local auth state management
│   ├── event_service.dart             # Firestore CRUD for events
│   ├── ticket_service.dart            # Firestore CRUD for tickets
│   ├── qr_service.dart               # QR generation and check-in logic
│   └── notification_service.dart      # Local and push notification handling
├── theme/
│   └── app_colors.dart                # App color palette
├── utils/
│   └── event_date_formatter.dart      # Date/time formatting utilities
└── widgets/
    ├── event_card.dart                # Reusable event card with seat badge
    ├── role_card.dart                 # Role selection card for registration
    ├── custom_button.dart             # Reusable styled button
    └── custom_textfield.dart          # Reusable styled text field
```

---

## Getting Started

### Prerequisites
- Flutter SDK (^3.11.0)
- Firebase project with Auth and Firestore enabled
- Android Studio or VS Code with Flutter extension

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eventify
   ```

2. **Configure Firebase**
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Enable **Email/Password Authentication**
   - Enable **Cloud Firestore** database
   - Update `lib/services/firebase_options.dart` with your project credentials

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Enable Developer Mode** (Windows)
   ```bash
   start ms-settings:developers
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## Firestore Collections

| Collection | Fields | Purpose |
|---|---|---|
| `users` | id, name, email, role, createdAt | User profiles with roles |
| `events` | id, title, location, description, dateTime, price, creatorId, creatorRole, capacity, attendeeCount, createdAt | Event data |
| `tickets` | id, eventId, eventTitle, eventDateTime, eventLocation, eventPrice, userId, qrCode, purchaseDate, isCheckedIn, checkInTime | Ticket records |
| `check_ins` | eventId, userId, qrCode, checkInTime | Check-in audit log |

---

## User Flows

### Attendee Flow
`Login → Home (browse events) → Event Details → Book Ticket → My Tickets (QR) → Calendar`

### Organizer Flow
`Login → My Events → Add Event → Attendees (Scan QR) → Analytics`

### Admin Flow
`Login → Dashboard (stats) → All Events → System Event (create) → Admin Settings`

---

## License

This project is for educational purposes.
