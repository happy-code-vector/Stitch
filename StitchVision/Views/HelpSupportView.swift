import SwiftUI

struct HelpSupportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateTo(.settings)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    Text("Help & Support")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    // Spacer for centering
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // FAQ Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Frequently Asked Questions")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                FAQItemView(
                                    question: "How accurate is the AI row counting?",
                                    answer: "Our AI achieves 95%+ accuracy in good lighting conditions. For best results, ensure your knitting is well-lit and the camera has a clear view."
                                )
                                
                                FAQItemView(
                                    question: "Can I use StitchVision with any yarn?",
                                    answer: "Yes! StitchVision works with most yarn types and colors. Darker yarns may require better lighting for optimal detection."
                                )
                                
                                FAQItemView(
                                    question: "What if the AI makes a mistake?",
                                    answer: "You can manually adjust the row count at any time using the +/- buttons. The AI learns from your corrections to improve accuracy."
                                )
                                
                                FAQItemView(
                                    question: "Does StitchVision work offline?",
                                    answer: "Basic row counting works offline. Pattern parsing and cloud sync require an internet connection."
                                )
                            }
                        }
                        
                        // Contact Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Us")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 12) {
                                ContactItemView(
                                    icon: "envelope",
                                    title: "Email Support",
                                    description: "Get help from our team",
                                    action: {
                                        // Handle email support
                                    }
                                )
                                
                                ContactItemView(
                                    icon: "message",
                                    title: "Live Chat",
                                    description: "Chat with us in real-time",
                                    action: {
                                        // Handle live chat
                                    }
                                )
                                
                                ContactItemView(
                                    icon: "book",
                                    title: "User Guide",
                                    description: "Learn how to use StitchVision",
                                    action: {
                                        // Handle user guide
                                    }
                                )
                            }
                        }
                        
                        // App Info
                        VStack(spacing: 8) {
                            Text("StitchVision v1.0.0")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            
                            Text("Made with ❤️ for knitters everywhere")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        .padding(.vertical, 32)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct FAQItemView: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            if isExpanded {
                VStack {
                    Divider()
                        .background(Color(red: 0.867, green: 0.867, blue: 0.867))
                    
                    Text(answer)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                .transition(.opacity.combined(with: .scale(scale: 1.0, anchor: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ContactItemView: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: title)
    }
}