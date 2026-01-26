import SwiftUI

struct HabitFrequencyView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFrequency: String?
    
    let frequencies = [
        ("daily", "Daily", "📅"),
        ("few-times-week", "Few times a week", "🗓️"),
        ("weekends", "Weekends only", "📆"),
        ("whenever", "Whenever I can", "🌙")
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
                    .animation(.easeOut(duration: 0.8), value: selectedFrequency)
                
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
                    Text("How often do you knit/crochet?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                Spacer()
                
                // Frequency options
                VStack(spacing: 16) {
                    ForEach(frequencies, id: \.0) { frequency in
                        FrequencyOptionView(
                            id: frequency.0,
                            label: frequency.1,
                            emoji: frequency.2,
                            isSelected: selectedFrequency == frequency.0
                        ) {
                            selectedFrequency = frequency.0
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    appState.navigateTo(.goal)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            selectedFrequency != nil 
                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedFrequency == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
    }
}

struct FrequencyOptionView: View {
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