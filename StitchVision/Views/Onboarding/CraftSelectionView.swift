import SwiftUI

struct CraftSelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCraft: String?
    @State private var animateElements = false
    
    let crafts = [
        ("knitting", "Knitting"),
        ("crochet", "Crochet"),
        ("both", "Both")
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
                    .scaleEffect(x: 0.1, y: 1, anchor: .leading)
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
                Text("What is your main craft?")
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
                
                // Craft cards - equal height vertical layout
                VStack(spacing: 16) {
                    ForEach(Array(crafts.enumerated()), id: \.offset) { index, craft in
                        CraftCardView(
                            craftType: craft.0,
                            label: craft.1,
                            isSelected: selectedCraft == craft.0,
                            delay: Double(index) * 0.1 + 0.1
                        ) {
                            selectedCraft = craft.0
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    // Save selected craft
                    appState.selectedCraft = selectedCraft
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
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedCraft == nil)
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

struct CraftCardView: View {
    let craftType: String
    let label: String
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Custom craft icon
                CraftIconView(craftType: craftType, isSelected: isSelected)
                
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(
                        isSelected 
                        ? Color(red: 0.173, green: 0.173, blue: 0.173)
                        : Color(red: 0.4, green: 0.4, blue: 0.4)
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected 
                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                        : Color.clear,
                        lineWidth: 4
                    )
            )
            .shadow(
                color: .black.opacity(isSelected ? 0.1 : 0.05),
                radius: isSelected ? 12 : 6,
                x: 0,
                y: isSelected ? 6 : 3
            )
            .scaleEffect(animate ? 1.0 : 0.9)
            .opacity(animate ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            animate = true
        }
    }
}

struct CraftIconView: View {
    let craftType: String
    let isSelected: Bool
    
    var iconColor: Color {
        isSelected 
        ? Color(red: 0.561, green: 0.659, blue: 0.533)
        : Color(red: 0.4, green: 0.4, blue: 0.4)
    }
    
    var body: some View {
        Group {
            switch craftType {
            case "knitting":
                KnittingNeedlesIcon(color: iconColor)
            case "crochet":
                CrochetHookIcon(color: iconColor)
            case "both":
                BothToolsIcon(color: iconColor)
            default:
                EmptyView()
            }
        }
        .frame(width: 48, height: 48)
    }
}

struct KnittingNeedlesIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Left needle
            Path { path in
                path.move(to: CGPoint(x: 12, y: 42))
                path.addLine(to: CGPoint(x: 21, y: 9))
            }
            .stroke(color, lineWidth: 2.5)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 5, height: 5)
                    .position(x: 21, y: 7)
            )
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 3, height: 3)
                    .position(x: 12, y: 42)
            )
            
            // Right needle
            Path { path in
                path.move(to: CGPoint(x: 36, y: 42))
                path.addLine(to: CGPoint(x: 27, y: 9))
            }
            .stroke(color, lineWidth: 2.5)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 5, height: 5)
                    .position(x: 27, y: 7)
            )
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 3, height: 3)
                    .position(x: 36, y: 42)
            )
            
            // Knitted work
            Path { path in
                path.move(to: CGPoint(x: 15, y: 30))
                path.addQuadCurve(to: CGPoint(x: 21, y: 27), control: CGPoint(x: 18, y: 27))
                path.addQuadCurve(to: CGPoint(x: 27, y: 30), control: CGPoint(x: 24, y: 33))
                path.addQuadCurve(to: CGPoint(x: 33, y: 27), control: CGPoint(x: 30, y: 27))
            }
            .stroke(color, lineWidth: 1.5)
            
            Path { path in
                path.move(to: CGPoint(x: 16, y: 35))
                path.addQuadCurve(to: CGPoint(x: 22, y: 32), control: CGPoint(x: 19, y: 32))
                path.addQuadCurve(to: CGPoint(x: 26, y: 35), control: CGPoint(x: 24, y: 38))
                path.addQuadCurve(to: CGPoint(x: 32, y: 32), control: CGPoint(x: 29, y: 32))
            }
            .stroke(color.opacity(0.7), lineWidth: 1.5)
        }
    }
}

struct CrochetHookIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Hook handle
            Path { path in
                path.move(to: CGPoint(x: 18, y: 42))
                path.addLine(to: CGPoint(x: 25, y: 12))
            }
            .stroke(color, lineWidth: 2.5)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 3, height: 3)
                    .position(x: 18, y: 42)
            )
            
            // Hook part
            Path { path in
                path.move(to: CGPoint(x: 25, y: 12))
                path.addQuadCurve(to: CGPoint(x: 29, y: 7), control: CGPoint(x: 25, y: 7))
                path.addQuadCurve(to: CGPoint(x: 31, y: 10), control: CGPoint(x: 31, y: 7))
            }
            .stroke(color, lineWidth: 2.5)
            
            // Crocheted work
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: 5, height: 5)
                .position(x: 21, y: 27)
            
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: 5, height: 5)
                .position(x: 27, y: 30)
            
            Circle()
                .stroke(color.opacity(0.7), lineWidth: 1.5)
                .frame(width: 5, height: 5)
                .position(x: 24, y: 33)
            
            Circle()
                .stroke(color.opacity(0.7), lineWidth: 1.5)
                .frame(width: 5, height: 5)
                .position(x: 30, y: 36)
        }
    }
}

struct BothToolsIcon: View {
    let color: Color
    
    var body: some View {
        ZStack {
            // Knitting needle
            Path { path in
                path.move(to: CGPoint(x: 9, y: 39))
                path.addLine(to: CGPoint(x: 17, y: 12))
            }
            .stroke(color, lineWidth: 2)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 3, height: 3)
                    .position(x: 17, y: 10)
            )
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 2, height: 2)
                    .position(x: 9, y: 39)
            )
            
            // Crochet hook
            Path { path in
                path.move(to: CGPoint(x: 39, y: 39))
                path.addLine(to: CGPoint(x: 31, y: 12))
            }
            .stroke(color, lineWidth: 2)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 2, height: 2)
                    .position(x: 39, y: 39)
            )
            
            Path { path in
                path.move(to: CGPoint(x: 31, y: 12))
                path.addQuadCurve(to: CGPoint(x: 34, y: 8), control: CGPoint(x: 31, y: 8))
                path.addQuadCurve(to: CGPoint(x: 36, y: 10), control: CGPoint(x: 36, y: 8))
            }
            .stroke(color, lineWidth: 2)
            
            // Work in progress between them
            Path { path in
                path.move(to: CGPoint(x: 15, y: 27))
                path.addQuadCurve(to: CGPoint(x: 33, y: 27), control: CGPoint(x: 24, y: 24))
            }
            .stroke(color, lineWidth: 1.5)
            
            Path { path in
                path.move(to: CGPoint(x: 16, y: 31))
                path.addQuadCurve(to: CGPoint(x: 32, y: 31), control: CGPoint(x: 24, y: 29))
            }
            .stroke(color.opacity(0.7), lineWidth: 1.5)
        }
    }
}

#Preview {
    CraftSelectionView()
        .environmentObject(AppState())
}