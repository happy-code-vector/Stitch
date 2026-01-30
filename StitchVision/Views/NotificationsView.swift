import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var appState: AppState
    @State private var dailyReminders = true
    @State private var projectUpdates = true
    @State private var achievementAlerts = false
    @State private var marketingEmails = false
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateTo(.settings)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    // Spacer for centering
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Push Notifications Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Push Notifications")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                NotificationToggleView(
                                    title: "Daily Knitting Reminders",
                                    description: "Get reminded to work on your projects",
                                    isOn: $dailyReminders
                                )
                                
                                NotificationToggleView(
                                    title: "Project Updates",
                                    description: "Notifications about your project progress",
                                    isOn: $projectUpdates
                                )
                                
                                NotificationToggleView(
                                    title: "Achievement Alerts",
                                    description: "Celebrate your knitting milestones",
                                    isOn: $achievementAlerts
                                )
                            }
                        }
                        
                        // Email Notifications Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Email Notifications")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                NotificationToggleView(
                                    title: "Marketing Emails",
                                    description: "Updates about new features and tips",
                                    isOn: $marketingEmails
                                )
                            }
                        }
                        
                        // Notification Schedule Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Schedule")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                ScheduleItemView(
                                    title: "Daily Reminder Time",
                                    value: "7:00 PM",
                                    action: {
                                        // Handle time picker
                                    }
                                )
                                
                                ScheduleItemView(
                                    title: "Quiet Hours",
                                    value: "10 PM - 8 AM",
                                    action: {
                                        // Handle quiet hours
                                    }
                                )
                            }
                        }
                        
                        // Info Section
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Notification Permissions")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    
                                    Text("To receive notifications, make sure StitchVision has permission in your device settings.")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                        .lineLimit(nil)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3), lineWidth: 1)
                            )
                            
                            Button(action: {
                                // Open device settings
                                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsUrl)
                                }
                            }) {
                                Text("Open Device Settings")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct NotificationToggleView: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .lineLimit(nil)
            }
            
            Spacer()
            
            // Custom Toggle Switch
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOn.toggle()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isOn ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.867, green: 0.867, blue: 0.867))
                        .frame(width: 48, height: 28)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ScheduleItemView: View {
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: title)
    }
}