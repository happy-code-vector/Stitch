import SwiftUI

struct PatternVerificationView: View {
    @EnvironmentObject var appState: AppState
    @State private var pattern: [PatternRow] = [
        PatternRow(id: 1, rowNumber: 1, instruction: "Cast on 60 stitches"),
        PatternRow(id: 2, rowNumber: 2, instruction: "Knit 4, Purl 4, repeat to end"),
        PatternRow(id: 3, rowNumber: 3, instruction: "Purl 4, Knit 4, repeat to end"),
        PatternRow(id: 4, rowNumber: 4, instruction: "Knit 4, Purl 4, repeat to end"),
        PatternRow(id: 5, rowNumber: 5, instruction: "Purl 4, Knit 4, repeat to end"),
        PatternRow(id: 6, rowNumber: 6, instruction: "Knit all stitches"),
        PatternRow(id: 7, rowNumber: 7, instruction: "Purl all stitches"),
        PatternRow(id: 8, rowNumber: 8, instruction: "Knit 2, Purl 2, repeat to end"),
    ]
    @State private var editingRow: Int? = nil
    @State private var editText = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Text("Pattern Check")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Spacer()
                    }
                    
                    Text("Review parsed instructions")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Info Banner
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        
                        Text("AI has parsed your pattern. Please verify each row before starting.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .lineLimit(nil)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .background(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                // Scrollable Pattern List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(pattern.enumerated()), id: \.element.id) { index, row in
                            PatternRowView(
                                row: row,
                                isEditing: editingRow == row.id,
                                editText: $editText,
                                onEditStart: {
                                    editingRow = row.id
                                    editText = row.instruction
                                },
                                onEditSave: {
                                    if let index = pattern.firstIndex(where: { $0.id == row.id }) {
                                        pattern[index].instruction = editText
                                    }
                                    editingRow = nil
                                    editText = ""
                                },
                                onEditCancel: {
                                    editingRow = nil
                                    editText = ""
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .padding(.bottom, 120) // Space for fixed footer
                }
            }
            
            // Fixed Bottom Footer
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    // Start Knitting Button
                    Button(action: {
                        appState.navigateTo(.workMode)
                    }) {
                        Text("Start Knitting")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pattern.count)
                    
                    // Discard Link
                    Button(action: {
                        appState.navigateTo(.dashboard)
                    }) {
                        Text("Discard & Retry")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .padding(.vertical, 8)
                    }
                    .scaleEffect(1.0)
                    .animation(.easeOut(duration: 0.6), value: pattern.count)
                }
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
}

// MARK: - Supporting Views

struct PatternRowView: View {
    let row: PatternRow
    let isEditing: Bool
    @Binding var editText: String
    let onEditStart: () -> Void
    let onEditSave: () -> Void
    let onEditCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if isEditing {
                // Edit Mode
                VStack(spacing: 12) {
                    HStack {
                        Text("Row \(row.rowNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button(action: onEditSave) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .clipShape(Circle())
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEditing)
                            
                            Button(action: onEditCancel) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 32, height: 32)
                                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                                    .clipShape(Circle())
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEditing)
                        }
                    }
                    
                    TextEditor(text: $editText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 1)
                        )
                        .frame(minHeight: 80)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            } else {
                // View Mode
                Button(action: onEditStart) {
                    HStack(spacing: 16) {
                        // Row Number
                        Text("Row \(row.rowNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 64, alignment: .leading)
                        
                        // Instruction Text
                        Text(row.instruction)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Edit Icon
                        Circle()
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEditing)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Data Models

struct PatternRow {
    let id: Int
    let rowNumber: Int
    var instruction: String
}