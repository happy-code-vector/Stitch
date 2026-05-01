import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var projectStore = ProjectStore()
    @State private var showStitchBot = false

    private let onboardingScreens: Set<ScreenType> = [
        .splash, .struggle, .statsProblem, .craft, .skill, .goal,
        .cameraPermissions, .subscription, .enhancedSubscription,
        .authentication, .freeVsProComparison, .downsell, .permissions,
        .calibration, .proGate, .proActivationConfirmation
    ]

    private var showStitchBotButton: Bool {
        !onboardingScreens.contains(appState.currentScreen)
            && appState.currentScreen != .stitchBot
            && appState.currentScreen != .workMode
    }

    var body: some View {
        Group {
            switch appState.currentScreen {
            case .splash:
                SplashView()
            case .struggle:
                StruggleView()
            case .statsProblem:
                StatsProblemView()
            case .craft:
                CraftSelectionView()
            case .skill:
                SkillLevelView()
            case .goal:
                GoalSettingView()
            case .cameraPermissions:
                CameraPermissionsView()
            case .subscription:
                SubscriptionView()
            case .enhancedSubscription:
                EnhancedSubscriptionView()
            case .authentication:
                AuthenticationView()
            case .freeVsProComparison:
                FreeVsProComparisonView(
                    onUpgrade: { appState.navigateTo(.enhancedSubscription) },
                    onDismiss: { appState.navigateTo(.dashboard) }
                )
            case .downsell:
                DownsellView()
            case .permissions:
                PermissionsView()
            case .calibration:
                CalibrationView()
            case .dashboard:
                DashboardView()
            case .workMode:
                WorkModeView()
            case .sessionSummary:
                SessionSummaryView(
                    rowsKnit: appState.sessionData.rowsKnit,
                    timeSpent: appState.sessionData.timeSpent,
                    sessionStartTime: appState.sessionData.startTime
                )
            case .settings:
                SettingsView()
            case .projectSetup:
                ProjectSetupView()
            case .projectDetail:
                ProjectDetailView()
            case .patternUpload:
                PatternUploadView()
            case .help:
                HelpSupportView()
            case .notifications:
                NotificationsView()
            case .profile:
                ProfileEditorView()
            case .analytics:
                AnalyticsView()
            case .abbreviationGlossary:
                AbbreviationGlossaryView()
            case .stitchBot:
                StitchBotChatView()
            case .proGate:
                ProGateView(onUpgrade: {
                    appState.navigateTo(.enhancedSubscription)
                }, onSkip: {
                    appState.navigateTo(.downsell)
                })
            case .proActivationConfirmation:
                ProActivationConfirmationView()
            }
        }
        .overlay {
            if showStitchBotButton {
                StitchBotFloatingButton {
                    showStitchBot = true
                }
            }
        }
        .sheet(isPresented: $showStitchBot) {
            StitchBotChatView()
                .environmentObject(appState)
                .environmentObject(projectStore)
        }
        .environmentObject(appState)
        .environmentObject(projectStore)
    }
}

#Preview {
    ContentView()
}
