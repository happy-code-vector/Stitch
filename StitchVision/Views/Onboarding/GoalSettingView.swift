import SwiftUI

struct GoalSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedGoal: String?
    @State private var animateProgress = false
    
    let goals = [
        ("finish-more", "Finish more projects", "🎯"),
        ("relax", "Relax and unwind", "🧘"),
        ("make-gifts", "Make gifts for loved ones", "🎁"),
        ("organize-stash", "Learn new techniques", "📚")
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()

            VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: animateProgress ? geo.size.width * 0.75 : 0, height: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .animation(.easeOut(duration: 0.8), value: animateProgress)
                }
            }
            .frame(height: 4)
            
            // Content
            VStack(spacing: 0) {
                // Back button
                HStack {
                    BackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                // Header
                VStack(spacing: 16) {
                    Text("What's your main goal?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                Spacer()
                
                // Goal options
                VStack(spacing: 16) {
                    ForEach(goals, id: \.0) { goal in
                        GoalOptionView(
                            id: goal.0,
                            label: goal.1,
                            emoji: goal.2,
                            isSelected: selectedGoal == goal.0
                        ) {
                            selectedGoal = goal.0
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    // Save selected goal
                    appState.goal = selectedGoal
                    appState.navigateTo(.patternLibraryPreview)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            selectedGoal != nil 
                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedGoal == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear { animateProgress = true }
    }
}

struct GoalOptionView: View {
    let id: String
    let label: String
    let emoji: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.4, green: 0.4, blue: 0.4))
                
                Text(label)
                    .font(.headline)
                    .foregroundColor(isSelected ? Color(red: 0.173, green: 0.173, blue: 0.173) : Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear,
                        lineWidth: 4
                    )
            )
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 12 : 8, x: 0, y: isSelected ? 6 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
