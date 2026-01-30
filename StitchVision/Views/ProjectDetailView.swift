import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var appState: AppState
    @State private var showDeleteConfirm = false
    
    // Sample project data - in real app this would come from data store
    let project = ProjectDetail(
        id: 1,
        name: "Winter Scarf",
        type: "scarf",
        progress: 68,
        totalRows: 120,
        completedRows: 82,
        lastWorked: "2h ago",
        needleSize: "5.0 mm",
        stitchType: "stockinette"
    )
    
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
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    Text("Project Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle edit
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Project Hero Card
                        VStack(spacing: 24) {
                            // Project Icon
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3),
                                            Color(red: 0.49, green: 0.57, blue: 0.46).opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 96, height: 96)
                                .overlay(
                                    Text(project.emoji)
                                        .font(.system(size: 48))
                                )
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: project.progress)
                            
                            // Project Name
                            VStack(spacing: 8) {
                                Text(project.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                Text("Last worked \(project.lastWorked)")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                            
                            // Progress Ring
                            ZStack {
                                Circle()
                                    .stroke(Color(red: 0.898, green: 0.898, blue: 0.898), lineWidth: 8)
                                    .frame(width: 128, height: 128)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(project.progress) / 100)
                                    .stroke(
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 128, height: 128)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeOut(duration: 1.5).delay(0.5), value: project.progress)
                                
                                VStack(spacing: 2) {
                                    Text("\(project.progress)%")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    
                                    Text("Complete")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                }
                                .opacity(1.0)
                                .animation(.easeOut(duration: 0.6).delay(0.8), value: project.progress)
                            }
                            
                            // Row Count
                            Text("Row \(project.completedRows) of \(project.totalRows)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 32)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                        
                        // Details Section
                        VStack(spacing: 0) {
                            // Section Header
                            HStack {
                                Text("DETAILS")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    .tracking(1)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.976, green: 0.969, blue: 0.949))
                            
                            // Detail Rows
                            VStack(spacing: 0) {
                                DetailRowView(
                                    label: "Rows Completed",
                                    value: "\(project.completedRows) / \(project.totalRows)"
                                )
                                
                                Divider()
                                    .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                
                                DetailRowView(
                                    label: "Progress",
                                    value: "\(project.progress)%",
                                    valueColor: Color(red: 0.561, green: 0.659, blue: 0.533)
                                )
                                
                                if let needleSize = project.needleSize {
                                    Divider()
                                        .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                    
                                    DetailRowView(
                                        label: "Needle Size",
                                        value: needleSize
                                    )
                                }
                                
                                if let stitchType = project.stitchType {
                                    Divider()
                                        .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                    
                                    DetailRowView(
                                        label: "Stitch Type",
                                        value: stitchType.capitalized
                                    )
                                }
                                
                                Divider()
                                    .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                                
                                DetailRowView(
                                    label: "Last Worked",
                                    value: project.lastWorked
                                )
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        
                        // Actions
                        VStack(spacing: 12) {
                            // Resume Knitting Button
                            Button(action: {
                                appState.navigateTo(.workMode)
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Resume Knitting")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: project.progress)
                            
                            // Delete Project Button
                            Button(action: {
                                showDeleteConfirm = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete Project")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(Color(red: 0.79, green: 0.43, blue: 0.37))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.79, green: 0.43, blue: 0.37), lineWidth: 2)
                                )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: project.progress)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
            
            // Delete Confirmation Modal
            if showDeleteConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDeleteConfirm = false
                    }
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Delete Project?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Text("This will permanently delete \"\(project.name)\" and all its progress. This action cannot be undone.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            showDeleteConfirm = false
                        }) {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                                )
                        }
                        
                        Button(action: {
                            showDeleteConfirm = false
                            appState.navigateTo(.dashboard)
                        }) {
                            Text("Delete")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.79, green: 0.43, blue: 0.37))
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                .scaleEffect(showDeleteConfirm ? 1.0 : 0.9)
                .opacity(showDeleteConfirm ? 1.0 : 0.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showDeleteConfirm)
            }
        }
    }
}

// MARK: - Supporting Views

struct DetailRowView: View {
    let label: String
    let value: String
    let valueColor: Color?
    
    init(label: String, value: String, valueColor: Color? = nil) {
        self.label = label
        self.value = value
        self.valueColor = valueColor
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(valueColor ?? Color(red: 0.173, green: 0.173, blue: 0.173))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

// MARK: - Data Models

struct ProjectDetail {
    let id: Int
    let name: String
    let type: String
    let progress: Int
    let totalRows: Int
    let completedRows: Int
    let lastWorked: String
    let needleSize: String?
    let stitchType: String?
    
    var emoji: String {
        switch type {
        case "scarf": return "🧣"
        case "beanie": return "🧢"
        case "sweater": return "🧶"
        case "mittens": return "🧤"
        case "blanket": return "🛏️"
        case "socks": return "🧦"
        default: return "🧶"
        }
    }
}