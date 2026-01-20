import SwiftUI

struct CraftSelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCraft: String?
    
    let crafts = [
        ("Knitting", "🧶", "Traditional knitting with needles"),
        ("Crochet", "🪝", "Single hook crochet work"),
        ("Both", "✨", "I do both knitting and crochet")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("What do you love to create?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                Text("Help us personalize your experience")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.top, 60)
            
            Spacer()
            
            // Craft options
            VStack(spacing: 20) {
                ForEach(crafts, id: \.0) { craft in
                    CraftOptionView(
                        title: craft.0,
                        emoji: craft.1,
                        description: craft.2,
                        isSelected: selectedCraft == craft.0
                    ) {
                        selectedCraft = craft.0
                    }
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Continue button
            Button(action: {
                appState.navigateTo(.skill)
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        selectedCraft != nil 
                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                        : Color.gray.opacity(0.5)
                    )
                    .cornerRadius(25)
            }
            .disabled(selectedCraft == nil)
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
    }
}

struct CraftOptionView: View {
    let title: String
    let emoji: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                
                Spacer()
                
                Circle()
                    .stroke(
                        isSelected 
                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                        : Color.gray.opacity(0.3),
                        lineWidth: 2
                    )
                    .background(
                        Circle()
                            .fill(
                                isSelected 
                                ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                : Color.clear
                            )
                    )
                    .frame(width: 24, height: 24)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CraftSelectionView()
        .environmentObject(AppState())
}