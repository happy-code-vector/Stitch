import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack {
            Group {
                switch appState.currentScreen {
                case .splash:
                    SplashView()
                case .craft:
                    CraftSelectionView()
                case .skill:
                    SkillLevelView()
                case .struggle:
                    StruggleView()
                case .statsProblem:
                    StatsProblemView()
                case .habit:
                    HabitFrequencyView()
                case .goal:
                    GoalSettingView()
                case .statsSolution:
                    StatsSolutionView()
                case .loading:
                    LoadingView()
                case .result:
                    ResultView()
                case .howItWorks:
                    HowItWorksView()
                case .stats:
                    StatsView()
                case .cameraPermissions:
                    CameraPermissionsView()
                case .calibration:
                    CalibrationView()
                case .subscription:
                    SubscriptionView()
                case .downsell:
                    DownsellView()
                case .permissions:
                    PermissionsView()
                case .freeTierWelcome:
                    FreeTierWelcomeView()
                case .dashboard:
                    DashboardView()
                case .workMode:
                    WorkModeView()
                case .sessionSummary:
                    SessionSummaryView()
                case .settings:
                    SettingsView()
                case .patternVerification:
                    PatternVerificationView()
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
                }
            }
        }
        .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}