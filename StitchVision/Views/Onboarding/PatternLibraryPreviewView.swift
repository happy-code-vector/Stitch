import SwiftUI

struct PatternLibraryPreviewView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPaywall = false

    // Sample patterns for preview
    private let previewPatterns: [(name: String, category: String, difficulty: String)] = [
        ("Beginner Scarf", "Accessories", "Easy"),
        ("Cozy Beanie", "Hats", "Easy"),
        ("Granny Square Blanket", "Blankets", "Easy"),
        ("Cable Knit Headband", "Accessories", "Medium"),
        ("Lace Shawl", "Shawls", "Medium"),
        ("Colorblock Sweater", "Clothing", "Advanced")
    ]

    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("🧶")
                        .font(.system(size: 48))

                    Text("Pattern Library")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))

                    Text("Choose from 80+ patterns to get started")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 60)
                .padding(.bottom, 32)

                // Pattern Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(previewPatterns, id: \.name) { pattern in
                        PatternPreviewCard(pattern: pattern) {
                            showPaywall = true
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue button
                Button(action: {
                    appState.navigateTo(.enhancedSubscription)
                }) {
                    Text("See All Patterns")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    Color(red: 0.49, green: 0.57, blue: 0.46)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPaywall) {
            PaywallView(feature: "Access Pattern Library")
        }
    }
}

struct PatternPreviewCard: View {
    let pattern: (name: String, category: String, difficulty: String)
    let onTap: () -> Void

    var difficultyColor: Color {
        switch pattern.difficulty {
        case "Easy": return Color(red: 0.561, green: 0.659, blue: 0.533)
        case "Medium": return Color(red: 0.949, green: 0.631, blue: 0.286)
        case "Advanced": return Color(red: 0.831, green: 0.502, blue: 0.435)
        default: return Color.gray
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Placeholder image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .aspectRatio(1, contentMode: .fit)

                    VStack(spacing: 4) {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        Text("Preview")
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .lineLimit(1)

                    HStack {
                        Text(pattern.category)
                            .font(.caption)
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))

                        Spacer()

                        Text(pattern.difficulty)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(difficultyColor.opacity(0.15))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    PatternLibraryPreviewView()
        .environmentObject(AppState())
}
