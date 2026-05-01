import SwiftUI

struct ProjectSetupView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @State private var projectName = ""
    @State private var needleSize = ""
    @State private var totalRowsText = ""
    @State private var selectedYarn: YarnStashItem? = nil
    @State private var aiCountingEnabled = true
    @State private var selectedCraftType = "Knitting"
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
            ThemeColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.goBack()
                    }) {
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(ThemeColors.primary)
                    }

                    Spacer()

                    Text("New Project")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(ThemeColors.textPrimary)

                    Spacer()

                    // Spacer for centering
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(ThemeColors.surface)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                // Scrollable Form Content
                ScrollView {
                    VStack(spacing: 32) {
                        // Section 0: Craft Type
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CRAFT TYPE")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
                                .tracking(1)
                                .padding(.horizontal, 16)

                            Picker("Craft Type", selection: $selectedCraftType) {
                                Text("Knitting").tag("Knitting")
                                Text("Crochet").tag("Crochet")
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        // Section 1: Details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DETAILS")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
                                .tracking(1)
                                .padding(.horizontal, 16)

                            VStack(spacing: 0) {
                                // Project Name Input
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Project Name")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .frame(width: 128, alignment: .leading)

                                        Spacer()

                                        TextField("Cozy Scarf", text: $projectName)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .multilineTextAlignment(.trailing)
                                            .disableAutocorrection(true)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }

                                Divider()
                                    .background(ThemeColors.border)

                                // Needle Size Input
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(selectedCraftType == "Crochet" ? "Hook Size" : "Needle Size")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .frame(width: 128, alignment: .leading)

                                        Spacer()

                                        TextField("5.0 mm", text: $needleSize)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .multilineTextAlignment(.trailing)
                                            .disableAutocorrection(true)
                                            .keyboardType(.decimalPad)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }

                                Divider()
                                    .background(ThemeColors.border)

                                // Total Rows Input
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Total Rows")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .frame(width: 128, alignment: .leading)

                                        Spacer()

                                        TextField("e.g. 100", text: $totalRowsText)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(ThemeColors.textPrimary)
                                            .multilineTextAlignment(.trailing)
                                            .disableAutocorrection(true)
                                            .keyboardType(.numberPad)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                            }
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        // Section 2: Materials
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MATERIALS")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
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
                                            .foregroundColor(ThemeColors.textPrimary)

                                        if let selectedYarn = selectedYarn {
                                            HStack(spacing: 8) {
                                                Text(selectedYarn.thumbnail)
                                                    .font(.title3)

                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(selectedYarn.name)
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(ThemeColors.textPrimary)
                                                    Text("\(selectedYarn.color) • \(selectedYarn.weight)")
                                                        .font(.system(size: 12, weight: .regular))
                                                        .foregroundColor(ThemeColors.textSecondary)
                                                }
                                            }
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(ThemeColors.textSecondary)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }

                                // Yarn Selector Dropdown
                                if showYarnSelector {
                                    VStack(spacing: 0) {
                                        Divider()
                                            .background(ThemeColors.border)

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
                                                                    .foregroundColor(ThemeColors.textPrimary)
                                                                Text("\(yarn.color) • \(yarn.weight)")
                                                                    .font(.system(size: 12, weight: .regular))
                                                                    .foregroundColor(ThemeColors.textSecondary)
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
                                                        .background(ThemeColors.background.opacity(0.5))
                                                    }

                                                    if yarn.id != yarnStash.last?.id {
                                                        Divider()
                                                            .background(ThemeColors.border)
                                                    }
                                                }
                                            }
                                        }
                                        .frame(maxHeight: 256)
                                    }
                                    .transition(.opacity.combined(with: .scale(scale: 1.0, anchor: .top)))
                                }
                            }
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        // Section 3: Pattern
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PATTERN")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
                                .tracking(1)
                                .padding(.horizontal, 16)

                            VStack(spacing: 0) {
                                // AI Counting Toggle
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Enable AI Counting")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(ThemeColors.textPrimary)
                                        Text("AI will detect and count rows via your camera")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(ThemeColors.textSecondary)
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
                                                .fill(aiCountingEnabled ? Color(red: 0.561, green: 0.659, blue: 0.533) : ThemeColors.border)
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
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        // Help Text
                        Text("Link your yarn stash to track usage and get accurate project estimates.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(ThemeColors.textSecondary)
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
                    Text("Start Project")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isFormValid ? .white : Color(red: 0.627, green: 0.596, blue: 0.565))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? ThemeColors.primary : Color(red: 0.831, green: 0.812, blue: 0.784))
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
                        colors: [ThemeColors.surface.opacity(0.8), ThemeColors.surface],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
    
    private func handleCreate() {
        guard isFormValid else { return }

        // Enforce free-tier project limit
        let subManager = SubscriptionManager.shared
        if !subManager.canCreateProject(currentCount: projectStore.projects.count) {
            appState.navigateTo(.proGate)
            return
        }

        let rows = Int(totalRowsText) ?? 0
        let newProject = ProjectModel(
            name: projectName,
            craftType: selectedCraftType,
            needleSize: needleSize,
            yarnType: selectedYarn?.name ?? "",
            yarnColor: selectedYarn?.color ?? "",
            patternName: "",
            totalRows: rows,
            currentRow: 0,
            status: "active"
        )

        projectStore.addProject(newProject)
        appState.navigateTo(.dashboard)
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
