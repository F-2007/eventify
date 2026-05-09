# Eventify Redesign & GitHub Integration - Step by Step Guide

## 📋 Project Redesign Plan

### **PHASE 1: Setup & Restructure (Steps 1-6)**
- Initialize Git & connect to GitHub
- Restructure project for role-based architecture
- Implement role selection

### **PHASE 2: Redesign Screens (Steps 7-12)**
- Fix attendee flow (Home, Events, Tickets)
- Build organizer dashboard
- Add proper navigation

### **PHASE 3: Firebase Integration (Steps 13+)**
- Connect Firebase
- Add QR codes
- Add notifications

---

## 🚀 STEP 1: Initialize Git (LOCAL)

Run in terminal:
```bash
cd d:\eventify
git init
git config user.name "Your Name"
git config user.email "your.email@gmail.com"
```

**What happens**: Creates a local `.git` folder to track changes

---

## 📚 STEP 2: Create .gitignore

This prevents large/sensitive files from being uploaded to GitHub.

**Files to add** (these will be created):
- `build/`, `android/.gradle/`, `ios/Pods/`, `.dart_tool/`
- `pubspec.lock`
- `.env` files (for secrets)

---

## 🌐 STEP 3: GitHub Repository Setup (YOU DO THIS IN BROWSER)

1. Go to **github.com** (login if needed)
2. Click **"+"** icon → **"New repository"**
3. Name it: **eventify**
4. Description: **Event Management App - Flutter + Firebase**
5. Choose **Public** or **Private**
6. **DO NOT** check "Initialize with README" (we already have files)
7. Click **"Create repository"**
8. Copy the commands shown (they'll look like below)

---

## 💾 STEP 4: Connect Local Project to GitHub

After creating the GitHub repo, run these commands:

```bash
cd d:\eventify

# Add all files to git
git add .

# First commit
git commit -m "Initial commit: Basic Flutter app structure"

# Add GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/eventify.git

# Rename branch to main (GitHub standard)
git branch -M main

# Push to GitHub
git push -u origin main
```

**After this**: Your code will be on GitHub!

---

## 📁 STEP 5: Restructure Screens Folder

**Current Structure** (CONFUSING):
```
screens/
├─ home_screen.dart
├─ login_screen.dart
├─ admin_screen.dart
├─ calendar_screen.dart
├─ tickets_screen.dart
├─ settings_screen.dart
├─ main_screen.dart
├─ add_event_screen.dart
├─ event_details_screen.dart
├─ register_screen.dart
└─ components/
```

**New Structure** (ORGANIZED BY ROLE):
```
screens/
├─ auth/
│  ├─ login_screen.dart
│  ├─ register_screen.dart
│  └─ role_selection_screen.dart (NEW)
├─ attendee/
│  ├─ attendee_main_screen.dart (RENAMED from main_screen.dart)
│  ├─ home_screen.dart (UPDATED - show real events)
│  ├─ event_details_screen.dart (MOVED - already exists)
│  ├─ upcoming_screen.dart (RENAMED from calendar_screen.dart)
│  ├─ my_tickets_screen.dart (RENAMED from tickets_screen.dart)
│  └─ profile_screen.dart (RENAMED from settings_screen.dart)
├─ organizer/
│  ├─ organizer_main_screen.dart (NEW)
│  ├─ my_events_screen.dart (NEW)
│  ├─ event_editor_screen.dart (RENAMED from add_event_screen.dart)
│  ├─ attendees_screen.dart (NEW)
│  ├─ analytics_screen.dart (NEW)
│  └─ profile_screen.dart (NEW)
├─ admin/
│  └─ admin_dashboard_screen.dart (REFACTORED from admin_screen.dart)
└─ components/
   └─ (existing widgets stay here)
```

---

## 🔐 STEP 6: Define User Model with Roles

Update `lib/models/user_model.dart`:

```dart
enum UserRole { attendee, organizer, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.byName(json['role']),
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'profileImage': profileImage,
    'createdAt': createdAt.toIso8601String(),
  };
}
```

---

## 🔄 STEP 7: Create Role Selection Screen

New file: `lib/screens/auth/role_selection_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Role'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How do you want to use Eventify?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Attendee Option
            _buildRoleCard(
              context,
              icon: Icons.person,
              title: 'Attendee',
              description: 'Browse and buy event tickets',
              onTap: () {
                // TODO: Save role and navigate to attendee home
                // Navigator.pushReplacementNamed(context, '/attendee-home');
              },
            ),
            const SizedBox(height: 20),
            
            // Organizer Option
            _buildRoleCard(
              context,
              icon: Icons.business,
              title: 'Organizer',
              description: 'Create and manage events',
              onTap: () {
                // TODO: Save role and navigate to organizer home
                // Navigator.pushReplacementNamed(context, '/organizer-home');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 STEP 8: Create Auth Service with Role Management

Update `lib/services/auth_service.dart`:

```dart
import '../models/user_model.dart';

class AuthService {
  static UserModel? _currentUser;
  
  static UserModel? get currentUser => _currentUser;
  
  static Future<bool> login(String email, String password) async {
    // TODO: Implement Firebase login
    // For now, mock user
    _currentUser = UserModel(
      id: '1',
      name: 'Test User',
      email: email,
      role: UserRole.attendee,
      createdAt: DateTime.now(),
    );
    return true;
  }
  
  static Future<void> setUserRole(UserRole role) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        role: role,
        profileImage: _currentUser!.profileImage,
        createdAt: _currentUser!.createdAt,
      );
      // TODO: Save to Firestore
    }
  }
  
  static Future<void> logout() async {
    _currentUser = null;
  }
}
```

---

## 🚦 STEP 9: Update main.dart for Role-Based Routing

```dart
import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(const EventifyApp());
}

class EventifyApp extends StatelessWidget {
  const EventifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventify',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: _getHomeScreen(),
    );
  }

  Widget _getHomeScreen() {
    final user = AuthService.currentUser;
    
    if (user == null) {
      return const LoginScreen();
    }
    
    // Route based on user role
    switch (user.role) {
      case UserRole.attendee:
        return const AttendeeMainScreen(); // TODO: Import and create
      case UserRole.organizer:
        return const OrganizerMainScreen(); // TODO: Import and create
      case UserRole.admin:
        return const AdminDashboardScreen(); // TODO: Import and create
    }
  }
}
```

---

## 📝 Git Commit After Each Step

After completing each step, commit to GitHub:

```bash
git add .
git commit -m "Step X: Description of changes"
git push origin main
```

Example commits:
```bash
git commit -m "Step 5: Restructure screens folder by role"
git commit -m "Step 6: Add UserModel with role support"
git commit -m "Step 7: Create role selection screen"
git commit -m "Step 8: Update auth service for roles"
git commit -m "Step 9: Update main.dart for role-based routing"
```

---

## ✅ Completion Checklist for Phase 1

- [ ] Git initialized locally
- [ ] GitHub repository created
- [ ] Project pushed to GitHub
- [ ] Screens folder restructured
- [ ] UserModel updated with roles
- [ ] Role selection screen created
- [ ] Auth service updated
- [ ] main.dart updated with role-based routing
- [ ] All changes committed to GitHub

**Once Phase 1 is complete**, we move to Phase 2: Rebuild screens for each role.
