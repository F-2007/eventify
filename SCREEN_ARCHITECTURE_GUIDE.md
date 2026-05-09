# Screen Architecture Analysis & Improvement Plan

## 🎯 Current Problems Identified

### 1. **No Clear App Purpose**
- Unclear if this is for event attendees, event organizers, or both
- No defined user personas or roles
- Confusing navigation flow

### 2. **Screen Issues**

| Screen | Problem | Impact |
|--------|---------|--------|
| **Home Screen** | Only UI - shows search bar but no actual event listing | Users can't discover events |
| **Main Screen** | Basic navigation without clear purpose for each tab | Confusing UX |
| **Admin Screen** | Isolated from main flow, minimal functionality | Admin features disconnected |
| **Login Screen** | No role selection or admin/user distinction | Can't differentiate users |

### 3. **Navigation Problems**
- No role-based routing (admin vs regular user)
- Admin screen is separate from main flow
- No clear hierarchy: Where does admin access come from?
- Tab purposes unclear (Home vs Calendar vs Tickets)

### 4. **Functional Gaps**
- Home screen doesn't display events
- No filtering/searching implementation
- Admin can only add events, can't manage them
- Calendar and Tickets screens purpose unclear

---

## 🏗️ Recommended Architecture

### **Define App Purpose & User Roles**

```
EVENTIFY - Event Management Platform

Purpose: Connect event attendees with event organizers

User Roles:
1. ATTENDEE (Regular User)
   - Browse and discover events
   - Book tickets
   - Check-in with QR code
   - Manage bookings
   - Get notifications

2. ORGANIZER (Event Creator)
   - Create and manage events
   - View attendees
   - Generate QR codes
   - Track check-ins
   - Analytics

3. ADMIN (Platform Admin)
   - Manage all events
   - Manage users
   - View platform analytics
   - Handle reports/issues
```

---

## 🔄 Refactored Navigation Structure

### **BEFORE (Current - Confused)**
```
Login → Main Screen (4 confusing tabs) + separate Admin Screen
         ├─ Home (lists events UI-only)
         ├─ Calendar (unclear)
         ├─ Tickets (unclear)
         └─ Settings
```

### **AFTER (Proposed - Clear)**
```
Splash Screen
    ↓
Login/Register
    ↓
Role Selection
    ├─ I'm an Attendee
    └─ I'm an Organizer
         ↓
         ├────────────────────────────────────┐
         ↓                                    ↓
    ATTENDEE FLOW                      ORGANIZER FLOW
    
    Main Screen (Bottom Nav)           Main Screen (Bottom Nav)
    ├─ Home                            ├─ My Events
    │  ├─ Event List                   │  ├─ Create Event
    │  ├─ Search/Filter                │  ├─ Edit Event
    │  └─ Event Details                │  └─ View Analytics
    │
    ├─ Upcoming (Calendar)             ├─ Attendees
    │  ├─ My Bookings                  │  ├─ List
    │  └─ Event Calendar               │  ├─ Check-in
    │                                  │  └─ Analytics
    ├─ My Tickets                      │
    │  ├─ Active Tickets               ├─ Analytics
    │  ├─ QR Check-in                  │  ├─ Revenue
    │  └─ Ticket History               │  ├─ Attendance
    │                                  │  └─ Trends
    └─ Profile                         │
       ├─ Settings                     └─ Profile
       ├─ Preferences                     ├─ Settings
       └─ Notifications                   └─ Account
```

---

## 📱 Detailed Screen Purposes

### **ATTENDEE SCREENS**

#### 1. **Home Screen** (Browse & Discover)
**Current**: Only UI, doesn't show events
**Should Be**:
- Featured events carousel
- Category filters (Concert, Sports, Workshop, etc.)
- Search functionality
- Event cards with:
  - Image
  - Title, Date, Location
  - Price, Rating
  - Attendee count
- Tap to view details

#### 2. **Event Details Screen** (View Full Info)
**Current**: Exists but needs enhancement
**Should Include**:
- Large event image/banner
- Title, organizer, date, time, location
- Description, capacity
- Price per ticket
- Attendee reviews/ratings
- "Book Now" button
- Map view location
- Similar events recommendation

#### 3. **Upcoming/Calendar Screen** (My Bookings)
**Current**: Named "Calendar" but unclear purpose
**Should Be**:
- Calendar view of booked events
- Upcoming events list
- Get reminder notifications
- One-tap QR check-in access
- Cancel booking option

#### 4. **My Tickets Screen** (Ticket Management)
**Current**: Empty/unclear
**Should Be**:
- Active tickets (upcoming events)
- Scan QR code for check-in
- Ticket details
- Digital ticket display
- Past tickets (history)

#### 5. **Profile Screen** (User Settings)
**Current**: "Settings" tab
**Should Be**:
- User info (name, email, phone)
- Notification preferences
- Payment methods
- Saved addresses
- Preferences (interests/categories)
- Logout

---

### **ORGANIZER SCREENS**

#### 1. **My Events Screen** (Event Management)
**Current**: Minimal admin dashboard
**Should Be**:
- List all created events
- Event cards showing:
  - Thumbnail
  - Status (Draft, Published, Ended)
  - Ticket sales count
  - Revenue
- Create new event (FAB button)
- Edit event (tap card)
- Delete/Archive event
- View analytics

#### 2. **Event Editor** (Create/Edit)
**Current**: "AddEventScreen" exists but basic
**Should Be**:
- Multi-step form:
  - Step 1: Basic info (title, category, description)
  - Step 2: Date, time, location
  - Step 3: Tickets (price, capacity, types)
  - Step 4: Images/media
  - Step 5: Publish/Save
- Rich text editor for description
- Image upload
- Price tiers
- Draft saving

#### 3. **Attendees/Check-in Screen**
**Current**: Doesn't exist
**Should Be**:
- Select event
- List of attendees:
  - Name, email, tickets purchased
  - Check-in status
- Scan QR code to check-in
- Mark attendance manually
- Export attendee list

#### 4. **Analytics Screen**
**Current**: Doesn't exist
**Should Be**:
- Event-specific stats:
  - Total attendees
  - Revenue
  - Check-in rate
- Charts (sales over time, etc.)
- Attendance trends
- Popular time slots

#### 5. **Profile Screen** (Organizer)
**Should Be**:
- Organizer info
- Bank details (payment)
- Tax info
- Event categories
- Notification settings
- Logout

---

## 🔐 Admin Controls (Separate Panel)
**Access**: Only for admin role, separate from user/organizer apps or admin settings in profile

**Should Include**:
- Dashboard with platform stats
- All events management
- All users management
- Reports/Issues
- System settings

---

## 🔄 Improved Login Flow

```dart
// NEW: Login with role selection
Login Screen
    ↓
- Enter email/password
- Backend checks user type
    ↓
    ├─ Admin → Admin Dashboard
    ├─ Organizer → Organizer Main Screen
    └─ Attendee → Attendee Main Screen
```

---

## 📋 Implementation Checklist

### Phase 1: Define & Restructure
- [ ] Define clear user roles (Attendee, Organizer, Admin)
- [ ] Create role-based navigation
- [ ] Restructure screens folder:
  ```
  screens/
  ├─ auth/
  │  ├─ login_screen.dart
  │  ├─ register_screen.dart
  │  └─ role_selection_screen.dart
  ├─ attendee/
  │  ├─ home_screen.dart
  │  ├─ event_details_screen.dart
  │  ├─ upcoming_screen.dart
  │  ├─ my_tickets_screen.dart
  │  └─ profile_screen.dart
  ├─ organizer/
  │  ├─ my_events_screen.dart
  │  ├─ event_editor_screen.dart
  │  ├─ attendees_screen.dart
  │  ├─ analytics_screen.dart
  │  └─ profile_screen.dart
  └─ admin/
     └─ admin_dashboard_screen.dart
  ```

### Phase 2: Implement Attendee Flow
- [ ] Fix Home Screen (display real events)
- [ ] Complete Event Details Screen
- [ ] Create proper Upcoming/Calendar Screen
- [ ] Create My Tickets Screen
- [ ] Create Attendee Profile Screen

### Phase 3: Implement Organizer Flow
- [ ] Create proper organizer dashboard
- [ ] Build event editor (multi-step)
- [ ] Create Attendees/Check-in Screen
- [ ] Create Analytics Screen
- [ ] Create Organizer Profile

### Phase 4: Navigation
- [ ] Implement role-based routing
- [ ] Add role selection after login
- [ ] Create proper navigation architecture
- [ ] Handle role switching if needed

---

## 💡 Key Improvements

1. **Clear Purpose**: Each screen has a specific function
2. **Better UX**: User's role is clear from navigation
3. **Separation of Concerns**: Different flows for different users
4. **Scalability**: Easy to add features per role
5. **Professional Structure**: Organized by feature/role

---

## 🎬 Quick Start Recommendation

1. **First**: Update login to include role selection
2. **Second**: Restructure screens folder
3. **Third**: Implement attendee flow (more users benefit from this)
4. **Fourth**: Implement organizer flow
5. **Fifth**: Add admin panel

This approach will create a **professional, clear, and scalable** event management app.
