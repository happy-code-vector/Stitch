# StitchVision iOS

This is the iOS version of the StitchVision knitting companion app, converted from the original Next.js web application.

## Overview

StitchVision is a knitting companion app that helps users track their knitting projects, count stitches using AI-powered computer vision, and maintain their knitting habits.

## Features

- **Onboarding Flow**: Personalized setup based on craft type, skill level, and goals
- **Project Management**: Create, track, and manage multiple knitting projects
- **AI Stitch Counting**: Camera-based stitch counting and progress tracking
- **Work Mode**: Focused knitting session with real-time feedback
- **Progress Analytics**: Track knitting habits and project completion
- **Pattern Support**: Upload and verify knitting patterns
- **Subscription Tiers**: Free and Pro tier functionality

## Architecture

The iOS app follows the MVVM (Model-View-ViewModel) pattern with SwiftUI:

### Structure
```
StitchVision/
├── Models/
│   ├── AppState.swift          # App navigation and state management
│   └── Project.swift           # Project data models
├── ViewModels/
│   └── ProjectStore.swift      # Project data management
├── Views/
│   ├── SplashView.swift        # Launch screen
│   ├── DashboardView.swift     # Main dashboard
│   ├── Onboarding/             # Onboarding flow screens
│   ├── Shared/                 # Reusable UI components
│   └── PlaceholderViews.swift  # Placeholder implementations
├── Services/                   # API and data services (future)
└── Assets.xcassets            # App icons and colors
```

### Key Components

1. **AppState**: Central state management for navigation and session data
2. **ProjectStore**: ObservableObject for managing project data
3. **Navigation**: Screen-based navigation using enum-driven state
4. **UI Components**: Custom SwiftUI views matching the original design

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Open `StitchVision.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project

## Current Implementation Status

### ✅ Completed
- Basic project structure and navigation
- Splash screen with animations
- Onboarding flow (craft selection, skill level)
- Dashboard with project overview
- Project data models and store
- UI components and styling

### 🚧 In Progress
- Complete onboarding flow implementation
- Work mode with camera integration
- Pattern upload and verification
- Settings and profile management

### 📋 Planned
- Core Data integration for persistence
- Camera and computer vision integration
- Push notifications
- Subscription management
- Advanced analytics and insights

## Design System

The app maintains the same design language as the web version:

- **Primary Color**: #8FA888 (Sage Green)
- **Background**: #F9F7F2 (Warm Off-White)
- **Text**: #2C2C2C (Dark Gray)
- **Secondary Text**: #666666 (Medium Gray)
- **Typography**: System fonts with custom weights
- **Animations**: Smooth transitions and micro-interactions

## Contributing

This iOS version is converted from the Next.js web application. When making changes:

1. Maintain consistency with the web version's UX flow
2. Follow iOS Human Interface Guidelines
3. Use SwiftUI best practices
4. Ensure accessibility compliance
5. Test on multiple device sizes

## Related Projects

- **Next.js Web App**: `../nextjs-app/` - Original web application
- **Shared Documentation**: `../nextjs-app/docs/` - Project requirements and specifications