import SwiftUI

struct ProfileEditorView: View {
    @EnvironmentObject var appState: AppState
    @State private var displayName = ""
    @State private var email = ""
    @State private var knittingExperience = "Intermediate"
    @State private var favoriteProjects = "Scarves & Blankets"
    @State private var showingImagePicker = false
    
    let experienceLevels = ["Beginner", "Intermediate", "Advanced", "Expert"]
    let projectTypes = ["Scarves & Blankets", "Sweaters & Cardigans", "Hats & Accessories", "Toys & Amigurumi", "Home Decor"]
    
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
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    Button(action: {
                        // Save profile changes to database
                        appState.updateUserProfile(name: displayName, email: email)
                        appState.navigateTo(.settings)
                    }) {
                        Text("Save")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Profile Photo Section
                        VStack(spacing: 16) {
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                                    Color(red: 0.49, green: 0.57, blue: 0.46)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Text("👋")
                                                .font(.system(size: 48))
                                        )
                                    
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Image(systemName: "camera")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                        )
                                        .opacity(0.0)
                                }
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: displayName)
                            
                            Text("Tap to change photo")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        // Basic Info Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("BASIC INFO")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .tracking(1)
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 0) {
                                ProfileFieldView(
                                    label: "Display Name",
                                    value: $displayName,
                                    placeholder: "Enter your name"
                                )
                                
                                Divider()
                                    .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                
                                ProfileFieldView(
                                    label: "Email",
                                    value: $email,
                                    placeholder: "Enter your email"
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                        // Knitting Preferences Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("KNITTING PREFERENCES")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .tracking(1)
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 0) {
                                ProfilePickerView(
                                    label: "Experience Level",
                                    value: $knittingExperience,
                                    options: experienceLevels
                                )
                                
                                Divider()
                                    .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                
                                ProfilePickerView(
                                    label: "Favorite Projects",
                                    value: $favoriteProjects,
                                    options: projectTypes
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                        // Account Actions Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ACCOUNT")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .tracking(1)
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                AccountActionView(
                                    icon: "key",
                                    title: "Change Password",
                                    action: {
                                        // Handle password change
                                    }
                                )
                                
                                AccountActionView(
                                    icon: "icloud",
                                    title: "Export Data",
                                    action: {
                                        // Handle data export
                                    }
                                )
                                
                                AccountActionView(
                                    icon: "trash",
                                    title: "Delete Account",
                                    isDestructive: true,
                                    action: {
                                        // Handle account deletion
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            // Image picker would go here
            Text("Image Picker")
        }
        .onAppear {
            // Load user data from AppState
            displayName = appState.userName ?? ""
            email = appState.userEmail ?? ""
            knittingExperience = appState.skillLevel ?? "Intermediate"
        }
    }
}

// MARK: - Supporting Views

struct ProfileFieldView: View {
    let label: String
    @Binding var value: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            TextField(placeholder, text: $value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                .multilineTextAlignment(.trailing)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

struct ProfilePickerView: View {
    let label: String
    @Binding var value: String
    let options: [String]
    @State private var showingPicker = false
    
    var body: some View {
        Button(action: {
            showingPicker = true
        }) {
            HStack {
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .actionSheet(isPresented: $showingPicker) {
            ActionSheet(
                title: Text("Select \(label)"),
                buttons: options.map { option in
                    .default(Text(option)) {
                        value = option
                    }
                } + [.cancel()]
            )
        }
    }
}

struct AccountActionView: View {
    let icon: String
    let title: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: String, title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(
                        isDestructive 
                        ? Color(red: 0.79, green: 0.43, blue: 0.37).opacity(0.1)
                        : Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(
                                isDestructive 
                                ? Color(red: 0.79, green: 0.43, blue: 0.37)
                                : Color(red: 0.561, green: 0.659, blue: 0.533)
                            )
                    )
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(
                        isDestructive 
                        ? Color(red: 0.79, green: 0.43, blue: 0.37)
                        : Color(red: 0.173, green: 0.173, blue: 0.173)
                    )
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        isDestructive 
                        ? Color(red: 0.79, green: 0.43, blue: 0.37).opacity(0.5)
                        : Color(red: 0.6, green: 0.6, blue: 0.6)
                    )
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