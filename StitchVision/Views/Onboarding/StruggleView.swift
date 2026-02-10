import SwiftUI

struct StruggleView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedStruggle: String?
    
    let struggles = [
        ("losing-count", "Losing count", "Having to recount rows constantly"),
        ("dropping-stitches", "Dropping stitches", "Missing errors until it's too late"),
        ("losing-patterns", "Losing patterns", "Patterns scattered everywhere"),
        ("not-finishing", "Not finishing projects", "Too many UFOs (unfinished objects)")
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
                    .animation(.easeOut(duration: 0.8), value: selectedStruggle)
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            // Content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("What frustrates you most?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                    
                    Text("We'll personalize your experience")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                Spacer()
                
                // Struggle options
                VStack(spacing: 16) {
                    ForEach(struggles, id: \.0) { struggle in
                        StruggleOptionView(
                            id: struggle.0,
                            title: struggle.1,
                            description: struggle.2,
                            isSelected: selectedStruggle == struggle.0
                        ) {
                            selectedStruggle = struggle.0
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    // Save selected struggle
                    if let struggle = selectedStruggle {
                        appState.struggles = [struggle]
                    }
                    appState.navigateTo(.statsProblem)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            selectedStruggle != nil 
                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedStruggle == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
    }
}

struct StruggleOptionView: View {
    let id: String
    let title: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Radio button
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
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                
                Spacer()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}