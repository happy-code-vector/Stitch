import SwiftUI

struct ProjectSetupView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @State private var projectName = ""
    @State private var needleSize = ""
    @State private var selectedYarn: YarnStashItem? = nil
    @State private var aiCountingEnabled = true
    @State private var showYarnSelector = false
    
    // Sample yarn stash items
    let yarnStash: [YarnStashItem] = [
        YarnStashItem(id: "1", name: "Merino Wool", color: "Forest Green", weight: "DK", thumbnail: "🧶"),
        YarnStashItem(id: "2", name: "Alpaca Blend", color: "Cream", weight: "Worsted", thumbnail: "🧵"),
        YarnStashItem(id: "3", name: "Cotton", color: "Navy Blue", weight: "Sport", thumbnail: "🧶"),
        YarnStashItem(id: "4", name: "Mohair", color: "Rose Pink", weight: "Lace", thumbnail: "🧵"),
    ]
    
    private var isFormValid: Bool {
        !projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateTo(.dashboard)
                    }) {
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                    
                    Spacer()
                    
                    Text("New Project")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    // Spacer for centering
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                // Scrollable Form Content
                ScrollView {
                    VStack(spacing: 32) {
                        // Section 1: Details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DETAILS")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .tracking(1)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                // Project Name Input
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Project Name")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            .frame(width: 128, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        TextField("Cozy Scarf", text: $projectName)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            .multilineTextAlignment(.trailing)
                                            .disableAutocorrection(true)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                
                                Divider()
                                    .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                
                                // Needle Size Input
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Needle Size")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            .frame(width: 128, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        TextField("5.0 mm", text: $needleSize)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            .multilineTextAlignment(.trailing)
                                            .disableAutocorrection(true)
                                            .keyboardType(.decimalPad)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                        // Section 2: Materials
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MATERIALS")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .tracking(1)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                // Yarn Selector Row
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        showYarnSelector.toggle()
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Text("Yarn")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        if let selectedYarn = selectedYarn {
                                            HStack(spacing: 8) {
                                                Text(selectedYarn.thumbnail)
                                                    .font(.title3)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(selectedYarn.name)
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                                    Text("\(selectedYarn.color) • \(selectedYarn.weight)")
                                                        .font(.system(size: 12, weight: .regular))
                                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.867, green: 0.867, blue: 0.867))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                
                                // Yarn Selector Dropdown
                                if showYarnSelector {
                                    VStack(spacing: 0) {
                                        Divider()
                                            .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                        
                                        ScrollView {
                                            VStack(spacing: 0) {
                                                ForEach(yarnStash, id: \.id) { yarn in
                                                    Button(action: {
                                                        selectedYarn = yarn
                                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                            showYarnSelector = false
                                                        }
                                                    }) {
                                                        HStack(spacing: 12) {
                                                            Text(yarn.thumbnail)
                                                                .font(.title3)
                                                            
                                                            VStack(alignment: .leading, spacing: 2) {
                                                                Text(yarn.name)
                                                                    .font(.system(size: 14, weight: .medium))
                                                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                                                Text("\(yarn.color) • \(yarn.weight)")
                                                                    .font(.system(size: 12, weight: .regular))
                                                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            if selectedYarn?.id == yarn.id {
                                                                Circle()
                                                                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                                                    .frame(width: 8, height: 8)
                                                            }
                                                        }
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 12)
                                                        .background(Color(red: 0.976, green: 0.969, blue: 0.949).opacity(0.5))
                                                    }
                                                    
                                                    if yarn.id != yarnStash.last?.id {
                                                        Divider()
                                                            .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                                    }
                                                }
                                            }
                                        }
                                        .frame(maxHeight: 256)
                                    }
                                    .transition(.opacity.combined(with: .scale(scale: 1.0, anchor: .top)))
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                        // Section 3: Pattern
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PATTERN")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .tracking(1)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                // AI Counting Toggle
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Enable AI Counting")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        Text("Let AI track your rows automatically")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    // Custom Toggle Switch
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            aiCountingEnabled.toggle()
                                        }
                                    }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(aiCountingEnabled ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.867, green: 0.867, blue: 0.867))
                                                .frame(width: 48, height: 28)
                                            
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 24, height: 24)
                                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                                .offset(x: aiCountingEnabled ? 10 : -10)
                                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: aiCountingEnabled)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                        // Help Text
                        Text("Link your yarn stash to track usage and get accurate project estimates.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .padding(.bottom, 100) // Space for fixed button
                }
            }
            
            // Fixed Bottom Create Button
            VStack {
                Spacer()
                
                Button(action: handleCreate) {
                    Text("Create Project")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isFormValid ? .white : Color(red: 0.5, green: 0.5, blue: 0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.8, green: 0.8, blue: 0.8))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(isFormValid ? 0.15 : 0.05), radius: isFormValid ? 8 : 2, x: 0, y: isFormValid ? 4 : 1)
                }
                .disabled(!isFormValid)
                .scaleEffect(isFormValid ? 1.0 : 0.98)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFormValid)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .background(
                    LinearGradient(
                        colors: [Color.white.opacity(0.8), Color.white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
    
    private func handleCreate() {
        if isFormValid {
            // Create new project and save to database
            let newProject = ProjectModel(
                name: projectName,
                craftType: appState.selectedCraft ?? "Knitting",
                needleSize: needleSize,
                yarnType: selectedYarn?.name ?? "",
                yarnColor: selectedYarn?.color ?? "",
                patternName: "",
                totalRows: 0,
                currentRow: 0,
                status: "active"
            )
            
            projectStore.addProject(newProject)
            appState.navigateTo(.dashboard)
        }
    }
}

// MARK: - Data Models

struct YarnStashItem {
    let id: String
    let name: String
    let color: String
    let weight: String
    let thumbnail: String
}