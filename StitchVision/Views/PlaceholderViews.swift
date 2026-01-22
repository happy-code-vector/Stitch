import SwiftUI

// MARK: - Onboarding Views
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

struct StatsProblemView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateStats = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Empathy Mascot
                    EmpathyMascotView()
                        .scaleEffect(animateStats ? 1.0 : 0.8)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateStats)
                    
                    // Headline
                    Text("You're Not Alone")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateStats)
                    
                    // Subtext
                    Text("Most knitters face the same frustrations:")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 10)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateStats)
                    
                    // Stats Cards
                    VStack(spacing: 16) {
                        StatCardView(
                            icon: "clock.fill",
                            statNumber: "4+ hours",
                            statLabel: "wasted per project",
                            description: "Time spent recounting rows after losing track",
                            delay: 0.4
                        )
                        
                        StatCardView(
                            icon: "exclamationmark.circle.fill",
                            statNumber: "73%",
                            statLabel: "lose track at least once",
                            description: "Every single knitting session, most crafters miscount",
                            delay: 0.5
                        )
                        
                        StatCardView(
                            icon: "face.dashed.fill",
                            statNumber: "1 in 3",
                            statLabel: "projects go unfinished",
                            description: "Counting frustration leads to abandoned projects",
                            delay: 0.6
                        )
                    }
                    
                    // Transition message
                    VStack(spacing: 16) {
                        HStack {
                            Text("But it doesn't have to be this way...")
                                .font(.body)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Text("💚")
                                .font(.title2)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        .cornerRadius(12)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateStats)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.habit)
                        }) {
                            Text("Show Me the Solution")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: animateStats)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateStats = true
        }
    }
}

struct StatCardView: View {
    let icon: String
    let statNumber: String
    let statLabel: String
    let description: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon circle
            Circle()
                .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(statNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                
                Text(statLabel)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.831, green: 0.502, blue: 0.435), lineWidth: 3)
                .padding(.leading, 0)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 1.5)
                )
                .mask(
                    Rectangle()
                        .frame(width: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
        )
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -30)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct EmpathyMascotView: View {
    @State private var heartBeat = false
    
    var body: some View {
        ZStack {
            // Main yarn ball body with empathetic expression
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 60
                    )
                )
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Yarn texture lines
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 30 * .pi / 180
                    let radius: CGFloat = 40
                    let startX = cos(angle) * radius * 0.3
                    let startY = sin(angle) * radius * 0.3
                    let endX = cos(angle) * radius * 0.7
                    let endY = sin(angle) * radius * 0.7
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                .opacity(0.6)
            }
            
            // Concerned/empathetic eyes
            HStack(spacing: 12) {
                Ellipse()
                    .fill(Color.black)
                    .frame(width: 6, height: 8)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 1, y: -1)
                    )
                
                Ellipse()
                    .fill(Color.black)
                    .frame(width: 6, height: 8)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 1, y: -1)
                    )
            }
            .offset(y: -8)
            
            // Concerned eyebrows
            HStack(spacing: 16) {
                Path { path in
                    path.move(to: CGPoint(x: -3, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -4))
                }
                .stroke(Color.black, lineWidth: 1.5)
                
                Path { path in
                    path.move(to: CGPoint(x: -7, y: -1))
                    path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -4))
                }
                .stroke(Color.black, lineWidth: 1.5)
            }
            .offset(y: -18)
            
            // Empathetic slight frown
            Path { path in
                path.move(to: CGPoint(x: -12, y: 15))
                path.addQuadCurve(to: CGPoint(x: 12, y: 15), control: CGPoint(x: 0, y: 12))
            }
            .stroke(Color.black, lineWidth: 1.5)
            
            // Rosy cheeks
            HStack(spacing: 24) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 12, height: 8)
                    .opacity(0.3)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 12, height: 8)
                    .opacity(0.3)
            }
            .offset(y: 5)
            
            // Small floating heart
            Text("💚")
                .font(.title3)
                .offset(x: 35, y: -35)
                .scaleEffect(heartBeat ? 1.2 : 1.0)
                .opacity(heartBeat ? 0.8 : 0.6)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: heartBeat)
        }
        .onAppear {
            heartBeat = true
        }
    }
}

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

struct GoalSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedGoal: String?
    
    let goals = [
        ("finish-more", "Finish more projects", "🎯"),
        ("relax", "Relax and unwind", "🧘"),
        ("make-gifts", "Make gifts for loved ones", "🎁"),
        ("organize-stash", "Learn new techniques", "📚")
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
                    .animation(.easeOut(duration: 0.8), value: selectedGoal)
                
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
                    appState.navigateTo(.statsSolution)
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
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
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

struct StatsSolutionView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateStats = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background sparkle elements
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 128, height: 128)
                .blur(radius: 30)
                .position(x: UIScreen.main.bounds.width - 80, y: 120)
                .scaleEffect(animateStats ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateStats)
            
            Circle()
                .fill(Color(red: 0.831, green: 0.686, blue: 0.216).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .position(x: 80, y: UIScreen.main.bounds.height - 160)
                .scaleEffect(animateStats ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true).delay(1), value: animateStats)
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Excited Mascot
                        ExcitedMascotView()
                            .scaleEffect(animateStats ? 1.0 : 0.8)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animateStats)
                        
                        // Headline
                        Text("With AI, Everything Changes")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .offset(y: animateStats ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateStats)
                        
                        // Subtext
                        Text("StitchVision users see incredible results:")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .offset(y: animateStats ? 0 : 10)
                            .animation(.easeOut(duration: 0.6).delay(0.3), value: animateStats)
                        
                        // Stats Cards - Positive outcomes
                        VStack(spacing: 16) {
                            SolutionStatCardView(
                                icon: "sparkles",
                                statNumber: "4+ hours",
                                statLabel: "saved per project",
                                description: "AI counts automatically—no more manual tracking",
                                delay: 0.4
                            )
                            
                            SolutionStatCardView(
                                icon: "chart.line.uptrend.xyaxis",
                                statNumber: "2x faster",
                                statLabel: "project completion",
                                description: "Finish scarves, sweaters, and blankets in half the time",
                                delay: 0.5
                            )
                            
                            SolutionStatCardView(
                                icon: "award.fill",
                                statNumber: "92%",
                                statLabel: "finish every project",
                                description: "No more abandoned WIPs (works in progress)",
                                delay: 0.6
                            )
                        }
                        
                        // Highlight message
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                Text("The Bottom Line")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 8)
                            
                            Text("You'll knit **more projects** in **less time**, with **zero frustration**.")
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    Color(red: 0.66, green: 0.76, blue: 0.63)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .scaleEffect(animateStats ? 1.0 : 0.9)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateStats)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.loading)
                        }) {
                            Text("Let's Get Started!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: animateStats)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateStats = true
        }
    }
}

struct SolutionStatCardView: View {
    let icon: String
    let statNumber: String
    let statLabel: String
    let description: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon circle
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(statNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                
                Text(statLabel)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
                .padding(.leading, 0)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 1.5)
                )
                .mask(
                    Rectangle()
                        .frame(width: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
        )
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -30)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct ExcitedMascotView: View {
    @State private var sparkleAnimation = false
    
    var body: some View {
        ZStack {
            // Main yarn ball body with excited expression
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Yarn texture lines
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 30 * .pi / 180
                    let radius: CGFloat = 50
                    let startX = cos(angle) * radius * 0.3
                    let startY = sin(angle) * radius * 0.3
                    let endX = cos(angle) * radius * 0.7
                    let endY = sin(angle) * radius * 0.7
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                .opacity(0.6)
            }
            
            // Excited sparkly eyes
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 12, height: 12)
                    .overlay(
                        VStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                                .offset(x: 1, y: -1)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 3, height: 3)
                                .offset(x: 2, y: 2)
                        }
                    )
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 12, height: 12)
                    .overlay(
                        VStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                                .offset(x: 1, y: -1)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 3, height: 3)
                                .offset(x: 2, y: 2)
                        }
                    )
            }
            .offset(y: -8)
            
            // Raised excited eyebrows
            HStack(spacing: 20) {
                Path { path in
                    path.move(to: CGPoint(x: -3, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -5))
                }
                .stroke(Color.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -7, y: -1))
                    path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -5))
                }
                .stroke(Color.black, lineWidth: 2)
            }
            .offset(y: -20)
            
            // Big happy smile
            Path { path in
                path.move(to: CGPoint(x: -20, y: 20))
                path.addQuadCurve(to: CGPoint(x: 20, y: 20), control: CGPoint(x: 0, y: 32))
            }
            .stroke(Color.black, lineWidth: 3)
            
            // Rosy excited cheeks
            HStack(spacing: 40) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.4)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.4)
            }
            .offset(y: 8)
            
            // Raised arms in celebration
            Path { path in
                path.move(to: CGPoint(x: -45, y: -10))
                path.addQuadCurve(to: CGPoint(x: -70, y: -35), control: CGPoint(x: -65, y: -15))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
            .opacity(0.8)
            
            Path { path in
                path.move(to: CGPoint(x: 45, y: -10))
                path.addQuadCurve(to: CGPoint(x: 70, y: -35), control: CGPoint(x: 65, y: -15))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
            .opacity(0.8)
            
            // Sparkles around mascot
            ForEach(0..<4, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [(-50, -25), (50, -25), (-40, 30), (50, 30)]
                let position = positions[index]
                
                Text("✨")
                    .font(.title2)
                    .offset(x: position.0, y: position.1)
                    .scaleEffect(sparkleAnimation ? 1.5 : 0.5)
                    .opacity(sparkleAnimation ? 1.0 : 0.0)
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: sparkleAnimation
                    )
            }
        }
        .onAppear {
            sparkleAnimation = true
        }
    }
}

struct LoadingView: View {
    @EnvironmentObject var appState: AppState
    @State private var progress: Double = 0
    @State private var messageIndex = 0
    @State private var isAnimating = false
    
    let loadingMessages = [
        "Analyzing your profile...",
        "Calibrating AI Model...",
        "Finding perfect patterns..."
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            // Rolling Yarn Ball Mascot
            RollingYarnBallView()
            
            // Yarn Thread becoming Loading Bar
            VStack(spacing: 16) {
                ZStack {
                    // Background bar
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Progress bar
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.66, green: 0.76, blue: 0.63)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, CGFloat(progress) * 200 / 100), height: 12)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                        
                        Spacer()
                    }
                    
                    // Animated shimmer effect
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.white.opacity(0.3), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 12)
                        .offset(x: isAnimating ? 100 : -100)
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                }
                .frame(width: 200)
            }
            
            // Cycling Text
            VStack {
                Text(loadingMessages[messageIndex])
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.5), value: messageIndex)
            }
            .frame(height: 24)
            
            // Tech accent dots
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .onAppear {
            isAnimating = true
            startLoading()
        }
    }
    
    private func startLoading() {
        // Cycle through messages
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            messageIndex = (messageIndex + 1) % loadingMessages.count
        }
        
        // Simulate progress
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if progress >= 100 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appState.navigateTo(.result)
                }
            } else {
                progress += 1
            }
        }
    }
}

struct RollingYarnBallView: View {
    @State private var isRotating = false
    @State private var yarnLength: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Rolling mascot
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    // Yarn texture lines
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 45 * .pi / 180
                            let radius: CGFloat = 50
                            let startX = cos(angle) * radius * 0.3
                            let startY = sin(angle) * radius * 0.3
                            let endX = cos(angle) * radius * 0.7
                            let endY = sin(angle) * radius * 0.7
                            
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 2)
                        .opacity(0.6)
                    }
                )
                .overlay(
                    // Eyes
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                    }
                    .offset(y: -8)
                )
                .overlay(
                    // Calm, focused smile
                    Path { path in
                        path.move(to: CGPoint(x: -12, y: 15))
                        path.addQuadCurve(to: CGPoint(x: 12, y: 15), control: CGPoint(x: 0, y: 20))
                    }
                    .stroke(Color.black, lineWidth: 2)
                )
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isRotating)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Unspooling yarn thread
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: 0, y: yarnLength),
                    control: CGPoint(x: sin(yarnLength * 0.1) * 10, y: yarnLength * 0.5)
                )
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .frame(height: 80)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: yarnLength)
            
            // Small yarn tail
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 10, y: -5))
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .offset(x: 30, y: -40)
            .rotationEffect(.degrees(isRotating ? -10 : 0))
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isRotating)
        }
        .onAppear {
            isRotating = true
            yarnLength = 80
        }
    }
}

struct ResultView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background Sparkles
            BackgroundSparklesView()
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title
                        Text("Your Crafting Profile")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                        
                        // Mascot with Trophy
                        ProudMascotWithTrophyView()
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateElements)
                        
                        // Badge Card
                        VStack(spacing: 16) {
                            // Badge icon
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.561, green: 0.659, blue: 0.533),
                                            Color(red: 0.49, green: 0.58, blue: 0.47)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                .rotationEffect(.degrees(animateElements ? 0 : -5))
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(2), value: animateElements)
                            
                            // Badge text
                            Text("You are a FOCUSED CREATOR")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                            
                            // Description
                            Text("You love the flow of knitting but hate interruptions like counting. StitchVision was built for you.")
                                .font(.body)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        .overlay(
                            // Decorative corner accents
                            VStack {
                                HStack {
                                    Spacer()
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .offset(x: 40, y: -40)
                                }
                                Spacer()
                                HStack {
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .offset(x: -40, y: 40)
                                    Spacer()
                                }
                            }
                        )
                        .clipped()
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                        
                        // Feature List Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Here's what StitchVision will do for you:")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 12) {
                                FeatureItemView(
                                    text: "Count rows automatically while you knit",
                                    delay: 1.1
                                )
                                FeatureItemView(
                                    text: "Detect dropped stitches with Stitch Doctor",
                                    delay: 1.2
                                )
                                FeatureItemView(
                                    text: "Track all your projects in one place",
                                    delay: 1.3
                                )
                                FeatureItemView(
                                    text: "Save 4+ hours per project",
                                    delay: 1.4
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.howItWorks)
                        }) {
                            Text("See How It Works")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.5), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct ProudMascotWithTrophyView: View {
    @State private var trophyFloat = false
    
    var body: some View {
        ZStack {
            // Trophy/Star held above
            VStack {
                Text("⭐")
                    .font(.system(size: 40))
                    .offset(y: trophyFloat ? -2 : 2)
                    .rotationEffect(.degrees(trophyFloat ? -3 : 3))
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: trophyFloat)
                
                Spacer()
            }
            .frame(height: 160)
            
            // Yarn ball body
            VStack {
                Spacer()
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.66, green: 0.76, blue: 0.63),
                                Color(red: 0.561, green: 0.659, blue: 0.533)
                            ],
                            center: .topLeading,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        // Yarn texture lines
                        ForEach(0..<6, id: \.self) { index in
                            Path { path in
                                let angle = Double(index) * 30 * .pi / 180
                                let radius: CGFloat = 40
                                let startX = cos(angle) * radius * 0.3
                                let startY = sin(angle) * radius * 0.3
                                let endX = cos(angle) * radius * 0.7
                                let endY = sin(angle) * radius * 0.7
                                
                                path.move(to: CGPoint(x: startX, y: startY))
                                path.addLine(to: CGPoint(x: endX, y: endY))
                            }
                            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                            .opacity(0.6)
                        }
                    )
                    .overlay(
                        // Happy, proud closed eyes
                        HStack(spacing: 16) {
                            Path { path in
                                path.move(to: CGPoint(x: -5, y: 0))
                                path.addQuadCurve(to: CGPoint(x: 5, y: 0), control: CGPoint(x: 0, y: 3))
                            }
                            .stroke(Color.black, lineWidth: 3)
                            
                            Path { path in
                                path.move(to: CGPoint(x: -5, y: 0))
                                path.addQuadCurve(to: CGPoint(x: 5, y: 0), control: CGPoint(x: 0, y: 3))
                            }
                            .stroke(Color.black, lineWidth: 3)
                        }
                        .offset(y: -8)
                    )
                    .overlay(
                        // Big proud smile
                        Path { path in
                            path.move(to: CGPoint(x: -15, y: 15))
                            path.addQuadCurve(to: CGPoint(x: 15, y: 15), control: CGPoint(x: 0, y: 25))
                        }
                        .stroke(Color.black, lineWidth: 3)
                    )
                    .overlay(
                        // Rosy cheeks
                        HStack(spacing: 30) {
                            Ellipse()
                                .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                                .frame(width: 12, height: 8)
                                .opacity(0.3)
                            
                            Ellipse()
                                .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                                .frame(width: 12, height: 8)
                                .opacity(0.3)
                        }
                        .offset(y: 8)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
            .frame(height: 160)
            
            // Arms reaching up to hold trophy
            VStack {
                HStack(spacing: 80) {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 20))
                        path.addQuadCurve(to: CGPoint(x: -10, y: 0), control: CGPoint(x: -15, y: 10))
                    }
                    .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 6)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 20))
                        path.addQuadCurve(to: CGPoint(x: 10, y: 0), control: CGPoint(x: 15, y: 10))
                    }
                    .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 6)
                }
                
                Spacer()
            }
            .frame(height: 160)
        }
        .onAppear {
            trophyFloat = true
        }
    }
}

struct BackgroundSparklesView: View {
    @State private var sparkleAnimation = false
    
    let sparklePositions: [(CGFloat, CGFloat)] = [
        (0.15, 0.1), (0.8, 0.2), (0.1, 0.4), (0.85, 0.6),
        (0.2, 0.8), (0.75, 0.7), (0.8, 0.3), (0.85, 0.5)
    ]
    
    var body: some View {
        ForEach(0..<sparklePositions.count, id: \.self) { index in
            let position = sparklePositions[index]
            
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                .opacity(0.4)
                .position(
                    x: position.0 * UIScreen.main.bounds.width,
                    y: position.1 * UIScreen.main.bounds.height
                )
                .scaleEffect(sparkleAnimation ? 1.0 : 0.0)
                .opacity(sparkleAnimation ? 0.4 : 0.0)
                .rotationEffect(.degrees(sparkleAnimation ? 360 : 0))
                .animation(
                    .easeInOut(duration: 3)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.5),
                    value: sparkleAnimation
                )
        }
        .onAppear {
            sparkleAnimation = true
        }
        
        // Additional decorative dots
        ForEach(0..<12, id: \.self) { index in
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                .frame(width: 4, height: 4)
                .position(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
                .scaleEffect(sparkleAnimation ? 1.0 : 0.5)
                .opacity(sparkleAnimation ? 0.6 : 0.2)
                .animation(
                    .easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2)),
                    value: sparkleAnimation
                )
        }
    }
}

struct FeatureItemView: View {
    let text: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 24, height: 24)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                )
            
            Text(text)
                .font(.body)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Spacer()
        }
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.4).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct HowItWorksView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentSlide = 0
    @State private var animateElements = false
    
    let slides = [
        HowItWorksSlide(
            title: "AI Watches While You Knit",
            description: "Just knit naturally—our AI counts every row automatically",
            visualType: .aiDetection
        ),
        HowItWorksSlide(
            title: "See Exactly What We Detect",
            description: "A glowing line shows where the AI is counting in real-time",
            visualType: .trustLine
        ),
        HowItWorksSlide(
            title: "Never Lose Your Place",
            description: "Pause anytime, adjust manually, or let the AI handle everything",
            visualType: .controlPanel
        )
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
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("How It Works")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    Text("See the magic in action")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                Spacer()
                
                // Slide Content
                VStack(spacing: 24) {
                    // Visual Demo
                    HowItWorksVisualView(slide: slides[currentSlide])
                        .frame(height: 280)
                        .id(currentSlide) // Force recreation for animations
                    
                    // Title & Description
                    VStack(spacing: 12) {
                        Text(slides[currentSlide].title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                        
                        Text(slides[currentSlide].description)
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 32)
                    
                    // Slide Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Capsule()
                                .fill(
                                    index == currentSlide 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                    : Color(red: 0.867, green: 0.867, blue: 0.867)
                                )
                                .frame(width: index == currentSlide ? 32 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentSlide)
                        }
                    }
                }
                
                Spacer()
                
                // Navigation Buttons
                HStack(spacing: 12) {
                    if currentSlide > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentSlide -= 1
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.caption)
                                Text("Back")
                                    .font(.headline)
                            }
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                            )
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    Button(action: {
                        if currentSlide < slides.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentSlide += 1
                            }
                        } else {
                            appState.navigateTo(.stats)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentSlide < slides.count - 1 ? "Next" : "See the Time Savings")
                                .font(.headline)
                            
                            if currentSlide < slides.count - 1 {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct HowItWorksSlide {
    let title: String
    let description: String
    let visualType: HowItWorksVisualType
}

enum HowItWorksVisualType {
    case aiDetection
    case trustLine
    case controlPanel
}

struct HowItWorksVisualView: View {
    let slide: HowItWorksSlide
    @State private var animateVisual = false
    
    var body: some View {
        Group {
            switch slide.visualType {
            case .aiDetection:
                AIDetectionVisualView()
            case .trustLine:
                TrustLineVisualView()
            case .controlPanel:
                ControlPanelVisualView()
            }
        }
        .onAppear {
            animateVisual = true
        }
    }
}

struct AIDetectionVisualView: View {
    @State private var scanningPosition: CGFloat = 0
    @State private var confidence: Double = 0
    @State private var rowCount = 42
    
    var body: some View {
        ZStack {
            // Camera background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.2, blue: 0.2),
                            Color(red: 0.3, green: 0.3, blue: 0.3),
                            Color(red: 0.25, green: 0.25, blue: 0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
            
            // Knitting texture pattern
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .overlay(
                    KnittingPatternView()
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            
            // AI Bounding Box
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
                .padding(32)
                .overlay(
                    // Corner brackets
                    VStack {
                        HStack {
                            CornerBracket(corners: [.topLeft])
                            Spacer()
                            CornerBracket(corners: [.topRight])
                        }
                        Spacer()
                        HStack {
                            CornerBracket(corners: [.bottomLeft])
                            Spacer()
                            CornerBracket(corners: [.bottomRight])
                        }
                    }
                    .padding(28)
                )
            
            // Scanning line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.8),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .padding(.horizontal, 32)
                .offset(y: scanningPosition)
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        scanningPosition = 100.0
                    }
                }
            
            // Row count display
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("\(rowCount)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("ROWS")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.6))
                            .background(.ultraThinMaterial)
                    )
                    
                    Spacer()
                }
                .padding(.bottom, 16)
            }
            
            // Confidence meter
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Confidence")
                                .font(.caption2)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(Int(confidence))%")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                            .overlay(
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                                    Color(red: 0.66, green: 0.76, blue: 0.63)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * confidence / 100)
                                }
                            )
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.4))
                            .background(.ultraThinMaterial)
                    )
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1).delay(0.8)) {
                confidence = 95
            }
        }
    }
}

struct TrustLineVisualView: View {
    @State private var glowIntensity: Double = 0.5
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Camera background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.2, blue: 0.2),
                            Color(red: 0.3, green: 0.3, blue: 0.3),
                            Color(red: 0.25, green: 0.25, blue: 0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
            
            // Knitting texture
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.clear)
                .overlay(
                    KnittingPatternView()
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            
            // AR Trust Line - centered
            VStack {
                Spacer()
                
                // Glowing trust line
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .padding(.horizontal, 32)
                    .shadow(
                        color: Color(red: 0.561, green: 0.659, blue: 0.533),
                        radius: glowIntensity * 20,
                        x: 0,
                        y: 0
                    )
                    .opacity(glowIntensity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            glowIntensity = 0.9
                        }
                    }
                
                Spacer()
            }
            
            // Floating "Row X" bubble
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Row 42")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.7))
                                .background(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3), lineWidth: 1)
                                )
                        )
                        .offset(y: floatingOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1)) {
                                floatingOffset = -5.0
                            }
                        }
                    
                    Spacer()
                }
                .padding(.top, 80)
                
                Spacer()
            }
            
            // Small mascot in corner
            VStack {
                HStack {
                    Spacer()
                    
                    SmallHappyMascotView()
                        .scaleEffect(0.6)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                
                Spacer()
            }
            
            // Label at bottom
            VStack {
                Spacer()
                
                Text("AI is watching here ↑")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 16)
            }
        }
    }
}

struct ControlPanelVisualView: View {
    @State private var isActive = true
    @State private var rowCount = 27
    
    var body: some View {
        VStack(spacing: 0) {
            // Top: Mini camera view
            ZStack {
                RoundedRectangle(cornerRadius: 16, corners: [.topLeft, .topRight])
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.2, blue: 0.2),
                                Color(red: 0.3, green: 0.3, blue: 0.3),
                                Color(red: 0.25, green: 0.25, blue: 0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                
                // Knitting texture
                RoundedRectangle(cornerRadius: 16, corners: [.topLeft, .topRight])
                    .fill(Color.clear)
                    .frame(height: 140)
                    .overlay(
                        KnittingPatternView()
                            .opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 16, corners: [.topLeft, .topRight]))
                    )
                
                // Row count display
                Text("\(rowCount)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Bottom: Control Panel
            VStack(spacing: 16) {
                // Status indicator
                HStack {
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: 8, height: 8)
                    
                    Text("Counting Active")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                
                // Control buttons
                HStack(spacing: 16) {
                    // Decrement button
                    Button(action: {
                        if rowCount > 0 {
                            rowCount -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                            )
                    }
                    
                    // Pause/Resume button (larger)
                    Button(action: {
                        isActive.toggle()
                    }) {
                        Image(systemName: isActive ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    
                    // Increment button
                    Button(action: {
                        rowCount += 1
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                            )
                    }
                }
                
                // Helper text
                Text("Adjust manually anytime without stopping")
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, corners: [.bottomLeft, .bottomRight]))
        }
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

// Helper Views
struct KnittingPatternView: View {
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / 20)
            let cols = Int(size.width / 20)
            
            for row in 0..<rows {
                for col in 0..<cols {
                    let x = CGFloat(col) * 20 + 10
                    let y = CGFloat(row) * 20 + 10
                    let offset: CGFloat = row % 2 == 0 ? 0 : 10
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x + offset, y: y, width: 6, height: 6)),
                        with: .color(Color(red: 0.62, green: 0.72, blue: 0.59).opacity(0.4))
                    )
                }
            }
        }
    }
}

struct CornerBracket: View {
    let corners: UIRectCorner
    
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .frame(width: 24, height: 24)
            .clipShape(CornerBracketShape(corners: corners))
    }
}

struct CornerBracketShape: Shape {
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if corners.contains(.topLeft) {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + 8))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + 8, y: rect.minY))
        }
        
        if corners.contains(.topRight) {
            path.move(to: CGPoint(x: rect.maxX - 8, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 8))
        }
        
        if corners.contains(.bottomLeft) {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 8))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 8, y: rect.maxY))
        }
        
        if corners.contains(.bottomRight) {
            path.move(to: CGPoint(x: rect.maxX - 8, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 8))
        }
        
        return path
    }
}

struct SmallHappyMascotView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 8,
                        endRadius: 24
                    )
                )
                .frame(width: 48, height: 48)
            
            // Happy eyes
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 0.5, y: -0.5)
                    )
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 0.5, y: -0.5)
                    )
            }
            .offset(y: -4)
            
            // Smile
            Path { path in
                path.move(to: CGPoint(x: -8, y: 6))
                path.addQuadCurve(to: CGPoint(x: 8, y: 6), control: CGPoint(x: 0, y: 12))
            }
            .stroke(Color.black, lineWidth: 1.5)
        }
    }
}

extension RoundedRectangle {
    init(cornerRadius: CGFloat, corners: UIRectCorner) {
        self.init(cornerRadius: cornerRadius)
    }
}

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Stats", nextScreen: .cameraPermissions)
    }
}

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Camera Permissions", nextScreen: .calibration)
    }
}

struct CalibrationView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Calibration", nextScreen: .subscription)
    }
}

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Subscription")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Button("Subscribe") {
                    appState.navigateTo(.permissions)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Skip") {
                    appState.navigateTo(.downsell)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct DownsellView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Special Offer")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Button("Accept") {
                    appState.navigateTo(.permissions)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Decline") {
                    appState.navigateTo(.permissions)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct PermissionsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Permissions", nextScreen: .freeTierWelcome)
    }
}

struct FreeTierWelcomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Free Tier Welcome", nextScreen: .dashboard)
    }
}

// MARK: - Main App Views
struct WorkModeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Work Mode")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Knitting in progress...")
                .font(.body)
                .foregroundColor(.gray)
            
            Button("Exit Session") {
                appState.updateSessionData(rowsKnit: 5, timeSpent: 25)
                appState.navigateTo(.sessionSummary)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct SessionSummaryView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Great Session!")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Text("Rows knit: \(appState.sessionData.rowsKnit)")
                Text("Time spent: \(appState.sessionData.timeSpent) minutes")
            }
            .font(.body)
            
            Button("Continue") {
                appState.navigateTo(.dashboard)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                Button("Profile") { appState.navigateTo(.profile) }
                Button("Notifications") { appState.navigateTo(.notifications) }
                Button("Help & Support") { appState.navigateTo(.help) }
                Button("Back to Dashboard") { appState.navigateTo(.dashboard) }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Other Views
struct PatternVerificationView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Pattern Verification", nextScreen: .dashboard)
    }
}

struct ProjectSetupView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Project Setup", nextScreen: .dashboard)
    }
}

struct ProjectDetailView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Project Detail", nextScreen: .dashboard)
    }
}

struct PatternUploadView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Pattern Upload", nextScreen: .dashboard)
    }
}

struct HelpSupportView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Help & Support", nextScreen: .dashboard)
    }
}

struct NotificationsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Notifications", nextScreen: .dashboard)
    }
}

struct ProfileEditorView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PlaceholderView(title: "Profile Editor", nextScreen: .dashboard)
    }
}

// MARK: - Helper Views
struct PlaceholderView: View {
    let title: String
    let nextScreen: ScreenType
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Button("Continue") {
                appState.navigateTo(nextScreen)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}