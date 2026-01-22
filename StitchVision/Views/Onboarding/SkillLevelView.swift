import SwiftUI

struct SkillLevelView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSkill: String?
    @State private var animateElements = false
    
    let skillLevels = [
        ("beginner", "Beginner", "Just starting out"),
        ("intermediate", "Intermediate", "Know the basics"),
        ("pro", "Advanced", "Skilled maker")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .scaleEffect(x: 0.2, y: 1, anchor: .leading)
                    .animation(.easeOut(duration: 0.8), value: animateElements)
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            // Content
            VStack(spacing: 0) {
                // Header
                Text("What's your skill level?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6), value: animateElements)
                
                Spacer()
                
                // Skill level options
                VStack(spacing: 16) {
                    ForEach(Array(skillLevels.enumerated()), id: \.offset) { index, skill in
                        SkillCardView(
                            skillType: skill.0,
                            title: skill.1,
                            description: skill.2,
                            isSelected: selectedSkill == skill.0,
                            delay: Double(index) * 0.1 + 0.1
                        ) {
                            selectedSkill = skill.0
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
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
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedSkill == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct SkillCardView: View {
    let skillType: String
    let title: String
    let description: String
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Skill icon
                SkillIconView(skillType: skillType, isSelected: isSelected)
                    .frame(width: 24, height: 24)
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected 
                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                        : Color.clear,
                        lineWidth: 3
                    )
            )
            .shadow(
                color: .black.opacity(isSelected ? 0.1 : 0.05),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
            .opacity(animate ? 1.0 : 0.0)
            .offset(x: animate ? 0 : -20)
            .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            animate = true
        }
    }
}

struct SkillIconView: View {
    let skillType: String
    let isSelected: Bool
    
    var iconColor: Color {
        isSelected 
        ? Color(red: 0.561, green: 0.659, blue: 0.533)
        : Color(red: 0.4, green: 0.4, blue: 0.4)
    }
    
    var body: some View {
        Group {
            switch skillType {
            case "beginner":
                SproutIcon(color: iconColor)
            case "intermediate":
                YarnBallIcon(color: iconColor)
            case "pro":
                StarIcon(color: iconColor)
            default:
                EmptyView()
            }
        }
    }
}

struct SproutIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Stem
            Path { path in
                path.move(to: CGPoint(x: 12, y: 22))
                path.addLine(to: CGPoint(x: 12, y: 14))
            }
            .stroke(color, lineWidth: 1.5)
            
            // Left leaf
            Path { path in
                path.move(to: CGPoint(x: 12, y: 14))
                path.addQuadCurve(to: CGPoint(x: 6, y: 9), control: CGPoint(x: 8, y: 11))
                path.addQuadCurve(to: CGPoint(x: 12, y: 12), control: CGPoint(x: 9, y: 8))
            }
            .fill(color.opacity(0.2))
            .overlay(
                Path { path in
                    path.move(to: CGPoint(x: 12, y: 14))
                    path.addQuadCurve(to: CGPoint(x: 6, y: 9), control: CGPoint(x: 8, y: 11))
                    path.addQuadCurve(to: CGPoint(x: 12, y: 12), control: CGPoint(x: 9, y: 8))
                }
                .stroke(color, lineWidth: 1)
            )
            
            // Right leaf
            Path { path in
                path.move(to: CGPoint(x: 12, y: 12))
                path.addQuadCurve(to: CGPoint(x: 18, y: 8), control: CGPoint(x: 15, y: 6))
                path.addQuadCurve(to: CGPoint(x: 12, y: 11), control: CGPoint(x: 16, y: 9))
            }
            .fill(color.opacity(0.2))
            .overlay(
                Path { path in
                    path.move(to: CGPoint(x: 12, y: 12))
                    path.addQuadCurve(to: CGPoint(x: 18, y: 8), control: CGPoint(x: 15, y: 6))
                    path.addQuadCurve(to: CGPoint(x: 12, y: 11), control: CGPoint(x: 16, y: 9))
                }
                .stroke(color, lineWidth: 1)
            )
        }
    }
}

struct YarnBallIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Main yarn ball
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 18, height: 18)
            
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: 18, height: 18)
            
            // Yarn texture lines
            Path { path in
                path.move(to: CGPoint(x: 6, y: 9))
                path.addQuadCurve(to: CGPoint(x: 18, y: 9), control: CGPoint(x: 12, y: 8))
            }
            .stroke(color, lineWidth: 1)
            .opacity(0.6)
            
            Path { path in
                path.move(to: CGPoint(x: 5, y: 12))
                path.addQuadCurve(to: CGPoint(x: 19, y: 12), control: CGPoint(x: 12, y: 11))
            }
            .stroke(color, lineWidth: 1)
            .opacity(0.6)
            
            Path { path in
                path.move(to: CGPoint(x: 6, y: 15))
                path.addQuadCurve(to: CGPoint(x: 18, y: 15), control: CGPoint(x: 12, y: 14))
            }
            .stroke(color, lineWidth: 1)
            .opacity(0.6)
            
            // Highlight
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 4, height: 4)
                .offset(x: -3, y: -3)
        }
    }
}

struct StarIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Star shape
            Path { path in
                let center = CGPoint(x: 12, y: 12)
                let outerRadius: CGFloat = 9
                let innerRadius: CGFloat = 4.5
                let points = 5
                
                for i in 0..<points * 2 {
                    let angle = Double(i) * .pi / Double(points)
                    let radius = i % 2 == 0 ? outerRadius : innerRadius
                    let x = center.x + cos(angle - .pi / 2) * radius
                    let y = center.y + sin(angle - .pi / 2) * radius
                    
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .fill(color.opacity(0.2))
            .overlay(
                Path { path in
                    let center = CGPoint(x: 12, y: 12)
                    let outerRadius: CGFloat = 9
                    let innerRadius: CGFloat = 4.5
                    let points = 5
                    
                    for i in 0..<points * 2 {
                        let angle = Double(i) * .pi / Double(points)
                        let radius = i % 2 == 0 ? outerRadius : innerRadius
                        let x = center.x + cos(angle - .pi / 2) * radius
                        let y = center.y + sin(angle - .pi / 2) * radius
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.closeSubpath()
                }
                .stroke(color, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    SkillLevelView()
        .environmentObject(AppState())
}