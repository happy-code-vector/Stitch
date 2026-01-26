import SwiftUI

// MARK: - Main App Views
struct WorkModeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 32) {
            Text("Work Mode")
                .font(.title)
                .fontWeight(.bold)

            Text("Knitting in progress...")
                .font(.body)
                .foregroundColor(.gray)

            Button("Exit Session") {
                appState.updateSessionData(rowsKnit: 5, timeSpent: 25)
                appState.navigateTo(.sessionSummary)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct SessionSummaryView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 32) {
            Text("Great Session!")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                Text("Rows knit: \(appState.sessionData.rowsKnit)")
                Text("Time spent: \(appState.sessionData.timeSpent) minutes")
            }
            .font(.body)

            Button("Continue") {
                appState.navigateTo(.dashboard)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            List {
                Button("Profile") { appState.navigateTo(.profile) }
                Button("Notifications") { appState.navigateTo(.notifications) }
                Button("Help & Support") { appState.navigateTo(.help) }
                Button("Back to Dashboard") { appState.navigateTo(.dashboard) }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Other Views
struct PatternVerificationView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Pattern Verification", nextScreen: .dashboard)
    }
}

struct ProjectSetupView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Project Setup", nextScreen: .dashboard)
    }
}

struct ProjectDetailView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Project Detail", nextScreen: .dashboard)
    }
}

struct PatternUploadView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Pattern Upload", nextScreen: .dashboard)
    }
}

struct HelpSupportView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Help & Support", nextScreen: .dashboard)
    }
}

struct NotificationsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Notifications", nextScreen: .dashboard)
    }
}

struct ProfileEditorView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        PlaceholderView(title: "Profile Editor", nextScreen: .dashboard)
    }
}

// MARK: - Helper Views
struct PlaceholderView: View {
    let title: String
    let nextScreen: ScreenType
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 32) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))

            Button("Continue") {
                appState.navigateTo(nextScreen)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}