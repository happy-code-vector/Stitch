import SwiftUI

struct SkillLevelView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSkill: String?
    
    let skillLevels = [
        ("Beginner", "Just starting out", "🌱"),
        ("Intermediate", "Know the basics", "🌿"),
        ("Advanced", "Experienced knitter", "🌳")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text("What's your skill level?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                Text("This helps us provide better guidance")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.top, 60)
            
            Spacer()
            
            VStack(spacing: 20) {
                ForEach(skillLevels, id: \.0) { skill in
                    SkillOptionView(
                        title: skill.0,
                        description: skill.1,
                        emoji: skill.2,
                        isSelected: selectedSkill == skill.0
                    ) {
                        selectedSkill = skill.0
                    }
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: {
                appState.navigateTo(.struggle)
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        selectedSkill != nil 
                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                        : Color.gray.opacity(0.5)
                    )
                    .cornerRadius(25)
            }
            .disabled(selectedSkill == nil)
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
    }
}

struct SkillOptionView: View {
    let title: String
    let description: String
    let emoji: String
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
    SkillLevelView()
        .environmentObject(AppState())
}