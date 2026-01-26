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
                    .frame(height: 140)
                
                // Knitting texture
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .frame(height: 140)
                    .overlay(
                        KnittingPatternView()
                            .opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
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
            .clipShape(RoundedRectangle(cornerRadius: 16))
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

struct ComparisonChartView: View {
    @State private var animateChart = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Project Completion Time")
                .font(.headline)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                .multilineTextAlignment(.center)
            
            ZStack {
                // Chart background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Savings Sticker - Top right corner
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("⚡")
                                .font(.title3)
                            
                            Text("SAVE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .tracking(0.5)
                            
                            Text("4.5hrs")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.831, green: 0.502, blue: 0.435), Color(red: 0.74, green: 0.45, blue: 0.39)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .rotationEffect(.degrees(6))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.degrees(6))
                        )
                        .scaleEffect(animateChart ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(1.2), value: animateChart)
                    }
                    .padding(.top, -16)
                    .padding(.trailing, -16)
                    
                    Spacer()
                }
                
                // Chart content
                VStack(spacing: 16) {
                    // Y-axis labels
                    HStack {
                        VStack(alignment: .trailing, spacing: 20) {
                            Text("12h")
                            Text("9h")
                            Text("6h")
                            Text("3h")
                            Text("0h")
                        }
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        // Bars
                        HStack(alignment: .bottom, spacing: 24) {
                            // Others Bar - TALLER (more time = bad)
                            VStack(spacing: 8) {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0.8, green: 0.8, blue: 0.8), Color(red: 0.9, green: 0.9, blue: 0.9)],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .frame(width: 60, height: animateChart ? 140 : 0)
                                    .cornerRadius(8)
                                    .overlay(
                                        VStack {
                                            Text("9 hrs")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                                .padding(.top, 8)
                                            
                                            Spacer()
                                        }
                                    )
                                    .animation(.easeOut(duration: 1).delay(0.3), value: animateChart)
                                
                                Text("Others")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                            
                            // StitchVision Bar - SHORTER (less time = good!)
                            VStack(spacing: 8) {
                                ZStack {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.66, green: 0.76, blue: 0.63)],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(width: 60, height: animateChart ? 70 : 0)
                                        .cornerRadius(8)
                                        .overlay(
                                            VStack {
                                                Text("4.5 hrs")
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                                    .padding(.top, 8)
                                                
                                                Spacer()
                                            }
                                        )
                                        .animation(.easeOut(duration: 1.2).delay(0.5), value: animateChart)
                                    
                                    // Sparkle effects
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            Text("✨")
                                                .font(.caption)
                                                .scaleEffect(animateChart ? 1.2 : 1.0)
                                                .opacity(animateChart ? 1.0 : 0.5)
                                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(2), value: animateChart)
                                        }
                                        .padding(.top, -8)
                                        .padding(.trailing, -8)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Text("StitchVision")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            }
                            
                            // Mascot celebrating next to StitchVision bar
                            VStack {
                                CelebratingMascotView()
                                    .scaleEffect(0.6)
                                    .offset(x: 20, y: -20)
                                    .opacity(animateChart ? 1.0 : 0.0)
                                    .scaleEffect(animateChart ? 0.6 : 0.4)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(1.5), value: animateChart)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 160)
                        
                        Spacer()
                    }
                    
                    // X-axis line
                    Rectangle()
                        .fill(Color(red: 0.867, green: 0.867, blue: 0.867))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                }
                .padding(20)
            }
        }
        .onAppear {
            animateChart = true
        }
    }
}

struct CelebratingMascotView: View {
    @State private var celebrateAnimation = false
    
    var body: some View {
        ZStack {
            // Yarn ball body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 15,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Yarn texture lines
            ForEach(0..<4, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 45 * .pi / 180
                    let radius: CGFloat = 30
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
            
            // Happy eyes
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 6, height: 6)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 1, y: -1)
                    )
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 6, height: 6)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .offset(x: 1, y: -1)
                    )
            }
            .offset(y: -6)
            
            // Big smile
            Path { path in
                path.move(to: CGPoint(x: -12, y: 8))
                path.addQuadCurve(to: CGPoint(x: 12, y: 8), control: CGPoint(x: 0, y: 18))
            }
            .stroke(Color.black, lineWidth: 2)
            
            // Raised arms in celebration
            Path { path in
                path.move(to: CGPoint(x: -30, y: -5))
                path.addQuadCurve(to: CGPoint(x: -45, y: -25), control: CGPoint(x: -40, y: -10))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 4)
            .rotationEffect(.degrees(celebrateAnimation ? -5 : 5))
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: celebrateAnimation)
            
            Path { path in
                path.move(to: CGPoint(x: 30, y: -5))
                path.addQuadCurve(to: CGPoint(x: 45, y: -25), control: CGPoint(x: 40, y: -10))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 4)
            .rotationEffect(.degrees(celebrateAnimation ? 5 : -5))
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: celebrateAnimation)
            
            // Sparkles around mascot
            ForEach(0..<3, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [(-35, -15), (35, -15), (0, -40)]
                let position = positions[index]
                
                Text("✨")
                    .font(.caption2)
                    .offset(x: position.0, y: position.1)
                    .scaleEffect(celebrateAnimation ? 1.2 : 0.8)
                    .opacity(celebrateAnimation ? 1.0 : 0.6)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: celebrateAnimation
                    )
            }
        }
        .onAppear {
            celebrateAnimation = true
        }
    }
}

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    
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
                    // Headline
                    Text("Finish Projects 2x Faster")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    // Social Proof Badge
                    HStack(spacing: 12) {
                        // Overlapping colored circles
                        HStack(spacing: -8) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.49, green: 0.58, blue: 0.47)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.831, green: 0.502, blue: 0.435), Color(red: 0.74, green: 0.45, blue: 0.39)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.831, green: 0.686, blue: 0.216), Color(red: 0.78, green: 0.64, blue: 0.20)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        
                        Text("Join knitters like you")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                    
                    // Bar Chart with Mascot
                    ComparisonChartView()
                        .opacity(animateElements ? 1.0 : 0.0)
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateElements)
                    
                    // Subtext
                    Text("Our users save an average of 4 hours per project by never recounting rows.")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                    
                    // Testimonial Card
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            Image(systemName: "quote.bubble.fill")
                                .font(.title)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2))
                        }
                        
                        Text("\"This saved my sanity! I used to spend so much time recounting. Now I just knit.\"")
                            .font(.body)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .italic()
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.49, green: 0.58, blue: 0.47)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("S")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sarah M.")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                Text("Pro Knitter")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                    
                    // Stats Cards
                    HStack(spacing: 12) {
                        VStack(spacing: 8) {
                            Text("4hrs")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("SAVED PER PROJECT")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .tracking(0.5)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.49, green: 0.58, blue: 0.47)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.66, green: 0.76, blue: 0.63), lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 8) {
                            Text("2x")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("FASTER COMPLETION")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .tracking(0.5)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.49, green: 0.58, blue: 0.47)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.66, green: 0.76, blue: 0.63), lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.8), value: animateElements)
                    
                    // CTA Button
                    Button(action: {
                        appState.navigateTo(.calibration)
                    }) {
                        Text("Set Up My AI Counter")
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
                    .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Decorative background circles
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: -100, y: -200)
                .scaleEffect(animateBackground ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateBackground)
            
            Circle()
                .fill(Color(red: 0.66, green: 0.76, blue: 0.63).opacity(0.3))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: 100, y: 200)
                .scaleEffect(animateBackground ? 1.0 : 1.3)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateBackground)
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .scaleEffect(x: 0.8, y: 1, anchor: .leading)
                        .animation(.easeOut(duration: 0.8), value: animateElements)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                Spacer()
                
                // Modal content
                VStack(spacing: 24) {
                    // Camera icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                    .scaleEffect(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    
                    VStack(spacing: 8) {
                        Text("Set Up Your AI Counter")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                        
                        Text("Quick 10-second setup")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: animateElements)
                    
                    VStack(spacing: 16) {
                        Text("StitchVision uses your camera to watch your knitting and count rows. **Camera-based row counting runs entirely on your device**—video is never saved or uploaded.")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        
                        Text("Note: Other AI features like Stitch Doctor use secure cloud processing.")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: animateElements)
                    
                    // Benefits list
                    VStack(spacing: 12) {
                        BenefitRow(icon: "✓", text: "AI Counting runs locally on-device")
                        BenefitRow(icon: "🔒", text: "Video stream is never saved")
                        BenefitRow(icon: "⚡", text: "Works offline")
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.6), value: animateElements)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            // Request camera permission here
                            appState.navigateTo(.calibration)
                        }) {
                            Text("Allow Camera Access")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            appState.navigateTo(.calibration)
                        }) {
                            Text("Maybe Later")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .padding(.vertical, 8)
                        }
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: animateElements)
                    
                    // Privacy note
                    Text("🔒 Your privacy is protected. Camera access is only used during active knitting sessions.")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                
                Spacer()
            }
        }
        .onAppear {
            animateElements = true
            animateBackground = true
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(icon)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            
            Spacer()
        }
    }
}

struct CalibrationView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var scanningPosition: CGFloat = -100
    @State private var confidence: Double = 0
    @State private var rowCount = 42
    
    var body: some View {
        ZStack {
            // Black camera background
            Color.black
                .ignoresSafeArea()
            
            // Simulated Camera Feed Background
            SimulatedCameraFeedView()
            
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
                
                // Header
                VStack(spacing: 8) {
                    Text("Let's calibrate your AI")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    Text("Quick 10-second setup to learn your knitting style")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                Spacer()
                
                // Center Detection Area
                VStack {
                    // Neon Detection Rectangle
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.922, green: 1.0, blue: 0.0), lineWidth: 4)
                        .frame(height: 200)
                        .background(Color.clear)
                        .shadow(color: Color(red: 0.922, green: 1.0, blue: 0.0), radius: 15, x: 0, y: 0)
                        .overlay(
                            // Corner indicators
                            VStack {
                                HStack {
                                    CornerIndicator(corners: [.topLeft])
                                    Spacer()
                                    CornerIndicator(corners: [.topRight])
                                }
                                Spacer()
                                HStack {
                                    CornerIndicator(corners: [.bottomLeft])
                                    Spacer()
                                    CornerIndicator(corners: [.bottomRight])
                                }
                            }
                            .padding(8)
                        )
                        .overlay(
                            // Scanning line animation
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            Color(red: 0.922, green: 1.0, blue: 0.0).opacity(0.8),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 2)
                                .offset(y: scanningPosition)
                                .onAppear {
                                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                        scanningPosition = 100
                                    }
                                }
                        )
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.3), value: animateElements)
                    
                    // Mascot peeking over bottom edge
                    PeekingMascotView()
                        .offset(y: -20)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6), value: animateElements)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Bottom UI Elements
                VStack(spacing: 16) {
                    // Row count display
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
                    
                    // Confidence meter
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
                    .padding(.horizontal, 16)
                    
                    // CTA Button
                    Button(action: {
                        appState.navigateTo(.subscription)
                    }) {
                        Text("Calibration Complete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(1.2), value: animateElements)
                }
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            animateElements = true
            
            // Animate confidence meter
            withAnimation(.easeOut(duration: 1).delay(0.8)) {
                confidence = 95
            }
        }
    }
}

struct SimulatedCameraFeedView: View {
    @State private var noiseOffset: CGFloat = 0
    @State private var lightingIntensity: Double = 0.3
    
    var body: some View {
        ZStack {
            // Base gradient to simulate lighting
            LinearGradient(
                colors: [
                    Color(red: 0.3, green: 0.3, blue: 0.3),
                    Color(red: 0.25, green: 0.25, blue: 0.25),
                    Color(red: 0.35, green: 0.35, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Simulated knitting texture in background
            KnittingPatternOverlayView()
                .opacity(0.3)
            
            // Vignette effect
            RadialGradient(
                colors: [Color.clear, Color.clear, Color.black.opacity(0.4)],
                center: .center,
                startRadius: 100,
                endRadius: 300
            )
            
            // Subtle moving light effect
            LinearGradient(
                colors: [Color.white.opacity(0.05), Color.clear, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(lightingIntensity)
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    lightingIntensity = 0.5
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct KnittingPatternOverlayView: View {
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / 20)
            let stitchesPerRow = Int(size.width / 15)
            
            for row in 0..<rows {
                for stitch in 0..<stitchesPerRow {
                    let x = CGFloat(stitch) * 15 + (row % 2 == 0 ? 0 : 7.5)
                    let y = CGFloat(row) * 20
                    
                    // Draw stitch as small oval
                    let stitchRect = CGRect(x: x, y: y, width: 12, height: 8)
                    let stitchPath = Path(ellipseIn: stitchRect)
                    
                    context.fill(stitchPath, with: .color(Color(red: 0.62, green: 0.72, blue: 0.59).opacity(0.4)))
                    
                    // Add connecting lines between stitches
                    if stitch < stitchesPerRow - 1 {
                        let startPoint = CGPoint(x: x + 12, y: y + 4)
                        let endPoint = CGPoint(x: x + 15, y: y + 4)
                        var linePath = Path()
                        linePath.move(to: startPoint)
                        linePath.addLine(to: endPoint)
                        
                        context.stroke(linePath, with: .color(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3)), lineWidth: 1.5)
                    }
                }
            }
        }
    }
}

struct CornerIndicator: View {
    let corners: UIRectCorner
    
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .stroke(Color(red: 0.922, green: 1.0, blue: 0.0), lineWidth: 4)
            .frame(width: 32, height: 32)
            .clipShape(
                CornerShape(corners: corners)
            )
    }
}

struct CornerShape: Shape {
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if corners.contains(.topLeft) {
            path.move(to: CGPoint(x: 0, y: 16))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 16, y: 0))
        }
        
        if corners.contains(.topRight) {
            path.move(to: CGPoint(x: rect.width - 16, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 16))
        }
        
        if corners.contains(.bottomLeft) {
            path.move(to: CGPoint(x: 0, y: rect.height - 16))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 16, y: rect.height))
        }
        
        if corners.contains(.bottomRight) {
            path.move(to: CGPoint(x: rect.width - 16, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 16))
        }
        
        return path
    }
}

struct PeekingMascotView: View {
    @State private var floatAnimation = false
    @State private var speechBubbleVisible = false
    
    var body: some View {
        ZStack {
            // Mascot peeking over
            VStack {
                Spacer()
                
                ZStack {
                    // Top of yarn ball
                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: 15,
                                endRadius: 35
                            )
                        )
                        .frame(width: 70, height: 60)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    // Yarn texture lines on visible part
                    ForEach(0..<3, id: \.self) { index in
                        Path { path in
                            let y = CGFloat(index - 1) * 8
                            path.move(to: CGPoint(x: -25, y: y))
                            path.addQuadCurve(to: CGPoint(x: 25, y: y), control: CGPoint(x: 0, y: y - 2))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                        .opacity(0.6)
                    }
                    
                    // Curious eyes looking down
                    HStack(spacing: 12) {
                        Ellipse()
                            .fill(Color.black)
                            .frame(width: 8, height: 10)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                        
                        Ellipse()
                            .fill(Color.black)
                            .frame(width: 8, height: 10)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                    }
                    .offset(y: -5)
                    
                    // Small curious smile
                    Path { path in
                        path.move(to: CGPoint(x: -8, y: 8))
                        path.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 0, y: 12))
                    }
                    .stroke(Color.black, lineWidth: 2)
                    
                    // Highlight for 3D effect
                    Ellipse()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 24, height: 16)
                        .offset(x: -8, y: -12)
                    
                    // Little hands/nubs gripping the edge
                    HStack(spacing: 50) {
                        Ellipse()
                            .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                            .frame(width: 16, height: 12)
                            .offset(y: 25)
                        
                        Ellipse()
                            .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                            .frame(width: 16, height: 12)
                            .offset(y: 25)
                    }
                }
                .offset(y: floatAnimation ? -2 : 2)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatAnimation)
            }
            .frame(height: 80)
            
            // Speech Bubble
            if speechBubbleVisible {
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 8) {
                            Text("Place your knitting here!")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .overlay(
                                    // Speech bubble tail
                                    VStack {
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Path { path in
                                                path.move(to: CGPoint(x: 0, y: 0))
                                                path.addLine(to: CGPoint(x: -8, y: 8))
                                                path.addLine(to: CGPoint(x: 8, y: 8))
                                                path.closeSubpath()
                                            }
                                            .fill(Color.white)
                                            .frame(width: 16, height: 8)
                                            .offset(x: -20, y: 4)
                                            
                                            Spacer()
                                        }
                                    }
                                )
                            
                            Spacer()
                        }
                        .offset(x: -60, y: -40)
                    }
                    
                    Spacer()
                }
                .opacity(speechBubbleVisible ? 1.0 : 0.0)
                .scaleEffect(speechBubbleVisible ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: speechBubbleVisible)
            }
        }
        .onAppear {
            floatAnimation = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                speechBubbleVisible = true
            }
        }
    }
}

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: PlanType = .proYearly
    @State private var selectedTier: PlanTier = .pro
    @State private var animateElements = false
    
    enum PlanType {
        case proYearly, proMonthly
    }
    
    enum PlanTier {
        case free, pro
    }
    
    let freeFeatures = [
        "AI Row Counting",
        "1 Active Project",
        "Basic Stitch Doctor"
    ]
    
    let proFeatures = [
        "AI Row Counting",
        "Unlimited Projects",
        "Advanced Stitch Doctor",
        "Unlimited Stash",
        "Pattern Library"
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Start your 7-Day Free Trial")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    // Tier Toggle
                    HStack(spacing: 4) {
                        Button(action: {
                            selectedTier = .free
                        }) {
                            Text("Free")
                                .font(.headline)
                                .foregroundColor(selectedTier == .free ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTier == .free 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                    : Color.clear
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(selectedTier == .free ? 0.1 : 0), radius: selectedTier == .free ? 8 : 0, x: 0, y: selectedTier == .free ? 4 : 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            selectedTier = .pro
                        }) {
                            Text("Pro")
                                .font(.headline)
                                .foregroundColor(selectedTier == .pro ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTier == .pro 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                    : Color.clear
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(selectedTier == .pro ? 0.1 : 0), radius: selectedTier == .pro ? 8 : 0, x: 0, y: selectedTier == .pro ? 4 : 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)
                    
                    // Plan Cards
                    if selectedTier == .free {
                        // Free Tier Card
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                Text("$0")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                Text("Free Forever")
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                            
                            VStack(spacing: 8) {
                                Text("1 Project Limit")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                Text("Perfect for trying StitchVision")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                            .cornerRadius(16)
                            
                            Text("No credit card required")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .italic()
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.4), value: animateElements)
                        
                    } else {
                        // Pro Plan Options
                        VStack(spacing: 16) {
                            // Pro Yearly Option
                            Button(action: {
                                selectedPlan = .proYearly
                            }) {
                                HStack(spacing: 16) {
                                    // Radio button
                                    Circle()
                                        .stroke(
                                            selectedPlan == .proYearly 
                                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                            : Color.gray.opacity(0.3),
                                            lineWidth: 2
                                        )
                                        .background(
                                            Circle()
                                                .fill(
                                                    selectedPlan == .proYearly 
                                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                                    : Color.clear
                                                )
                                        )
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 12, height: 12)
                                                .opacity(selectedPlan == .proYearly ? 1.0 : 0.0)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Yearly Pro")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Text("$6.67/mo")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Save 50%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                                            .cornerRadius(12)
                                        
                                        Text("$79.99/year")
                                            .font(.caption)
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                    }
                                }
                                .padding(20)
                                .background(
                                    selectedPlan == .proYearly 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                                    : Color(red: 0.95, green: 0.95, blue: 0.95)
                                )
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            selectedPlan == .proYearly 
                                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                            : Color.clear,
                                            lineWidth: 4
                                        )
                                )
                                .shadow(color: .black.opacity(selectedPlan == .proYearly ? 0.1 : 0.05), radius: selectedPlan == .proYearly ? 12 : 8, x: 0, y: selectedPlan == .proYearly ? 6 : 2)
                                .scaleEffect(selectedPlan == .proYearly ? 1.02 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: selectedPlan)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Pro Monthly Option
                            Button(action: {
                                selectedPlan = .proMonthly
                            }) {
                                HStack(spacing: 16) {
                                    // Radio button
                                    Circle()
                                        .stroke(
                                            selectedPlan == .proMonthly 
                                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                            : Color.gray.opacity(0.3),
                                            lineWidth: 2
                                        )
                                        .background(
                                            Circle()
                                                .fill(
                                                    selectedPlan == .proMonthly 
                                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                                    : Color.clear
                                                )
                                        )
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 12, height: 12)
                                                .opacity(selectedPlan == .proMonthly ? 1.0 : 0.0)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Monthly Pro")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Text("$12.99/mo")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(20)
                                .background(
                                    selectedPlan == .proMonthly 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                                    : Color(red: 0.95, green: 0.95, blue: 0.95)
                                )
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            selectedPlan == .proMonthly 
                                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                            : Color.clear,
                                            lineWidth: 4
                                        )
                                )
                                .shadow(color: .black.opacity(selectedPlan == .proMonthly ? 0.1 : 0.05), radius: selectedPlan == .proMonthly ? 12 : 8, x: 0, y: selectedPlan == .proMonthly ? 6 : 2)
                                .scaleEffect(selectedPlan == .proMonthly ? 1.02 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: selectedPlan)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.4), value: animateElements)
                    }
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 16) {
                        Text(selectedTier == .free ? "Free Includes" : "Pro Includes")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(spacing: 12) {
                            ForEach(Array((selectedTier == .free ? freeFeatures : proFeatures).enumerated()), id: \.offset) { index, feature in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    
                                    Text(feature)
                                        .font(.body)
                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    
                                    Spacer()
                                }
                                .opacity(animateElements ? 1.0 : 0.0)
                                .offset(x: animateElements ? 0 : -20)
                                .animation(.easeOut(duration: 0.5).delay(0.5 + Double(index) * 0.1), value: animateElements)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
                    
                    // CTA Button
                    Button(action: {
                        appState.navigateTo(.permissions)
                    }) {
                        Text(selectedTier == .free ? "Continue with Free" : "Start Free Trial")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                    
                    // Disclaimer for Pro
                    if selectedTier == .pro {
                        Text("Cancel anytime")
                            .font(.body)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.9), value: animateElements)
                    }
                    
                    // Skip link
                    Button(action: {
                        appState.navigateTo(.downsell)
                    }) {
                        Text(selectedTier == .free ? "Skip" : "Skip trial")
                            .font(.body)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .underline()
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                    
                    // Footer Links
                    HStack(spacing: 16) {
                        Button("Restore Purchases") {
                            // Restore purchases logic
                        }
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Text("•")
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Button("Terms of Service") {
                            // Open Terms of Service
                        }
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Text("•")
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Button("Privacy Policy") {
                            // Open Privacy Policy
                        }
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(1.1), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct DownsellView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var urgencyPulse = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Urgency background elements
            Circle()
                .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .frame(width: 128, height: 128)
                .blur(radius: 30)
                .position(x: UIScreen.main.bounds.width - 80, y: 120)
                .scaleEffect(urgencyPulse ? 1.3 : 1.0)
                .opacity(urgencyPulse ? 0.2 : 0.1)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: urgencyPulse)
            
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .position(x: 80, y: UIScreen.main.bounds.height - 160)
                .scaleEffect(urgencyPulse ? 1.2 : 1.0)
                .opacity(urgencyPulse ? 0.15 : 0.1)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1), value: urgencyPulse)
            
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
                        // Mascot with 50% OFF tag
                        ExcitedMascotWithTagView()
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .rotationEffect(.degrees(animateElements ? 0 : -10))
                            .animation(.spring(response: 0.6, dampingFraction: 0.5), value: animateElements)
                        
                        // Headline
                        Text("Wait! Don't Miss Out.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateElements)
                        
                        // Subtext
                        Text("We want you to experience the magic of AI knitting. Get your first year of Pro for half off.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.easeOut(duration: 0.5).delay(0.3), value: animateElements)
                        
                        // Price Card
                        VStack(spacing: 20) {
                            // Special Offer Badge
                            HStack {
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    
                                    Text("Limited Time")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .scaleEffect(urgencyPulse ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: urgencyPulse)
                            }
                            .padding(.top, -16)
                            .padding(.trailing, -16)
                            
                            // Pricing
                            VStack(spacing: 12) {
                                // Old Price
                                HStack {
                                    Text("$19.99/mo")
                                        .font(.title3)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        .strikethrough(true, color: Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Spacer()
                                }
                                
                                // New Price
                                HStack {
                                    Text("$9.99")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Text("/mo")
                                        .font(.title)
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Spacer()
                                }
                                
                                // Savings callout
                                HStack {
                                    Text("Save $120 per year")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Spacer()
                                }
                            }
                            
                            // Features reminder
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Everything Pro includes:")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(spacing: 8) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("AI Row Counting")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Stitch Doctor")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Unlimited Projects")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 16)
                            .overlay(
                                Rectangle()
                                    .fill(Color(red: 0.976, green: 0.969, blue: 0.949))
                                    .frame(height: 2)
                                    .padding(.horizontal, -24),
                                alignment: .top
                            )
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.831, green: 0.502, blue: 0.435), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
                        
                        // Primary CTA
                        Button(action: {
                            appState.navigateTo(.permissions)
                        }) {
                            Text("Claim 50% Off Offer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.6), value: animateElements)
                        
                        // Secondary Decline Link
                        Button(action: {
                            appState.navigateTo(.permissions)
                        }) {
                            Text("No thanks, continue with limited Free Plan")
                                .font(.body)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .underline()
                                .multilineTextAlignment(.center)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.5).delay(0.8), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
            urgencyPulse = true
        }
    }
}

struct ExcitedMascotWithTagView: View {
    @State private var tagFloat = false
    @State private var sparkleAnimation = false
    
    private var tagContent: some View {
        VStack(spacing: 4) {
            Text("50%")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("OFF")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.91, green: 0.61, blue: 0.55),
                    Color(red: 0.831, green: 0.502, blue: 0.435),
                    Color(red: 0.78, green: 0.46, blue: 0.40)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private var tagHole: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 12, height: 12)
            .overlay(
                Circle()
                    .stroke(Color(red: 0.78, green: 0.46, blue: 0.40), lineWidth: 2)
            )
            .offset(x: 40, y: -20)
            .rotationEffect(.degrees(6))
    }
    
    private var yarnBallBody: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.66, green: 0.76, blue: 0.63),
                        Color(red: 0.561, green: 0.659, blue: 0.533)
                    ],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 50
                )
            )
            .frame(width: 100, height: 100)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var yarnTexture: some View {
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
    }
    
    private var mascotEyes: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.black)
                .frame(width: 14, height: 14)
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
                .frame(width: 14, height: 14)
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
    }
    
    private var mascotMouth: some View {
        Ellipse()
            .fill(Color.black.opacity(0.8))
            .frame(width: 24, height: 30)
            .overlay(
                Ellipse()
                    .fill(Color(red: 0.976, green: 0.969, blue: 0.949).opacity(0.3))
                    .frame(width: 16, height: 20)
            )
            .offset(y: 15)
    }
    
    private var mascotEyebrows: some View {
        HStack(spacing: 20) {
            Path { path in
                path.move(to: CGPoint(x: -3, y: -2))
                path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -5))
            }
            .stroke(Color.black, lineWidth: 2.5)
            
            Path { path in
                path.move(to: CGPoint(x: -7, y: -1))
                path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -5))
            }
            .stroke(Color.black, lineWidth: 2.5)
        }
        .offset(y: -22)
    }
    
    private var mascotHighlight: some View {
        Ellipse()
            .fill(Color.white.opacity(0.3))
            .frame(width: 36, height: 26)
            .offset(x: -16, y: -16)
    }
    
    private var mascotArms: some View {
        VStack {
            HStack(spacing: 80) {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 20))
                    path.addQuadCurve(to: CGPoint(x: -20, y: -10), control: CGPoint(x: -25, y: 5))
                }
                .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 20))
                    path.addQuadCurve(to: CGPoint(x: 20, y: -10), control: CGPoint(x: 25, y: 5))
                }
                .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
            }
            
            Spacer()
        }
        .frame(height: 100)
    }
    
    private var tagSparkle: some View {
        Text("✨")
            .font(.caption)
            .offset(x: -30, y: -15)
            .rotationEffect(.degrees(6))
            .scaleEffect(sparkleAnimation ? 1.3 : 1.0)
            .opacity(sparkleAnimation ? 1.0 : 0.8)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: sparkleAnimation)
    }
    
    var body: some View {
        ZStack {
            // 50% OFF Tag held up
            VStack {
                HStack {
                    Spacer()
                    
                    tagContent
                        .rotationEffect(.degrees(6))
                        .offset(y: tagFloat ? -3 : 3)
                        .rotationEffect(.degrees(tagFloat ? -5 : 5))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: tagFloat)
                        .overlay(tagHole)
                        .overlay(tagSparkle)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .frame(height: 200)
            
            // Yarn ball mascot body
            VStack {
                Spacer()
                
                yarnBallBody
                    .overlay(yarnTexture)
                    .overlay(mascotEyes)
                    .overlay(mascotMouth)
                    .overlay(mascotEyebrows)
                    .overlay(mascotHighlight)
                    .overlay(mascotArms)
                
                Spacer()
            }
            .frame(height: 200)
            
            // Excitement sparkles around mascot
            ForEach(0..<6, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [
                    (-60, -20), (60, -20), (-40, 40), (50, 40), (-70, 10), (70, 10)
                ]
                let position = positions[index]
                
                Text("✨")
                    .font(.caption2)
                    .offset(x: position.0, y: position.1)
                    .scaleEffect(sparkleAnimation ? 1.5 : 0.0)
                    .opacity(sparkleAnimation ? 1.0 : 0.0)
                    .rotationEffect(.degrees(sparkleAnimation ? 180 : 0))
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: sparkleAnimation
                    )
            }
        }
        .onAppear {
            tagFloat = true
            sparkleAnimation = true
        }
    }
}

struct PermissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background pattern
            Canvas { context, size in
                let rows = Int(size.height / 80)
                let cols = Int(size.width / 80)
                
                for row in 0..<rows {
                    for col in 0..<cols {
                        let x = CGFloat(col) * 80 + 20
                        let y = CGFloat(row) * 80 + 20
                        let offset: CGFloat = row % 2 == 0 ? 0 : 40
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x + offset, y: y, width: 4, height: 4)),
                            with: .color(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        )
                    }
                }
            }
            
            // Decorative background circles
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 120, height: 120)
                .blur(radius: 40)
                .offset(x: 80, y: -150)
                .scaleEffect(animateBackground ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateBackground)
            
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: -80, y: 200)
                .scaleEffect(animateBackground ? 1.0 : 1.3)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true).delay(1), value: animateBackground)
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .scaleEffect(x: 0.95, y: 1, anchor: .leading)
                        .animation(.easeOut(duration: 0.8), value: animateElements)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                Spacer()
                
                // Modal content
                VStack(spacing: 24) {
                    // Bell icon with gradient background
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.49, green: 0.57, blue: 0.46)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    
                    VStack(spacing: 16) {
                        Text("Don't lose your streak")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                        
                        Text("Allow notifications so the AI Coach can remind you to finish that sweater.")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            // Request notification permission here
                            appState.navigateTo(.freeTierWelcome)
                        }) {
                            Text("Allow")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            appState.navigateTo(.freeTierWelcome)
                        }) {
                            Text("Maybe Later")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.vertical, 12)
                        }
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: animateElements)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                
                Spacer()
            }
        }
        .onAppear {
            animateElements = true
            animateBackground = true
        }
    }
}

struct FreeTierWelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var animateSparkles = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Blurred background elements to simulate home screen
            VStack(spacing: 16) {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 64)
                    .cornerRadius(16)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                    .padding(.top, 80)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 128)
                    .cornerRadius(24)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 96)
                    .cornerRadius(24)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                Capsule()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 80)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
            }
            
            // Dark overlay
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .animation(.easeOut(duration: 0.8), value: animateElements)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                Spacer()
                
                // Modal content
                VStack(spacing: 0) {
                    // Mascot with folder (floating above modal)
                    MascotWithFolderView()
                        .offset(y: -60)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Welcome to the Starter Plan!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                            
                            Text("You have access to **1 Active Smart Project** with full AI Vision features. Finish it to start a new one, or upgrade anytime to multitask.")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)
                        
                        Button(action: {
                            appState.navigateTo(.dashboard)
                        }) {
                            Text("Let's Cast On!")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
                                )
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.5).delay(0.6), value: animateElements)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .padding(.top, 40) // Extra space for floating mascot
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                }
                .padding(.horizontal, 24)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                
                Spacer()
            }
            
            // Sparkle decorations
            SparkleView(x: 80, y: 120, delay: 0)
            SparkleView(x: 300, y: 200, delay: 0.7)
        }
        .onAppear {
            animateElements = true
            animateSparkles = true
        }
    }
}

struct MascotWithFolderView: View {
    var body: some View {
        ZStack {
            // Project folder/ticket held up
            VStack {
                ZStack {
                    // Golden folder
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.957, green: 0.898, blue: 0.627),
                                    Color(red: 0.831, green: 0.686, blue: 0.216),
                                    Color(red: 0.788, green: 0.635, blue: 0.196)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1.5)
                        )
                    
                    // Folder tab
                    Path { path in
                        path.move(to: CGPoint(x: -30, y: -15))
                        path.addLine(to: CGPoint(x: -30, y: -20))
                        path.addQuadCurve(to: CGPoint(x: -25, y: -25), control: CGPoint(x: -30, y: -25))
                        path.addLine(to: CGPoint(x: -10, y: -25))
                        path.addLine(to: CGPoint(x: -5, y: -15))
                        path.closeSubpath()
                    }
                    .fill(Color(red: 0.831, green: 0.686, blue: 0.216))
                    .overlay(
                        Path { path in
                            path.move(to: CGPoint(x: -30, y: -15))
                            path.addLine(to: CGPoint(x: -30, y: -20))
                            path.addQuadCurve(to: CGPoint(x: -25, y: -25), control: CGPoint(x: -30, y: -25))
                            path.addLine(to: CGPoint(x: -10, y: -25))
                            path.addLine(to: CGPoint(x: -5, y: -15))
                        }
                        .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1.5)
                    )
                    
                    // Decorative lines on folder
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(Color(red: 0.788, green: 0.635, blue: 0.196))
                            .frame(width: 40, height: 1.5)
                        Rectangle()
                            .fill(Color(red: 0.788, green: 0.635, blue: 0.196))
                            .frame(width: 25, height: 1.5)
                        Rectangle()
                            .fill(Color(red: 0.788, green: 0.635, blue: 0.196))
                            .frame(width: 30, height: 1.5)
                    }
                    
                    // Star icon
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.957, green: 0.898, blue: 0.627))
                        .offset(x: 15, y: -8)
                    
                    // Shine effect
                    Ellipse()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 30, height: 20)
                        .offset(x: -10, y: -5)
                }
                .offset(y: -40)
                
                Spacer()
            }
            
            // Yarn ball mascot
            VStack {
                Spacer()
                
                ZStack {
                    // Main body
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: 15,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    // Yarn texture
                    ForEach(0..<4, id: \.self) { index in
                        Path { path in
                            let y = 40 + CGFloat(index - 2) * 8
                            path.move(to: CGPoint(x: 15, y: y))
                            path.addQuadCurve(to: CGPoint(x: 65, y: y), control: CGPoint(x: 40, y: y - 3))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                        .opacity(0.6)
                    }
                    
                    // Happy eyes
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 6, height: 6)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 1, height: 1)
                                    .offset(x: 2, y: 1)
                            )
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 6, height: 6)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 3, height: 3)
                                    .offset(x: 1, y: -1)
                            )
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 1, height: 1)
                                    .offset(x: 2, y: 1)
                            )
                    }
                    .offset(y: -8)
                    
                    // Big smile
                    Path { path in
                        path.move(to: CGPoint(x: 25, y: 48))
                        path.addQuadCurve(to: CGPoint(x: 55, y: 48), control: CGPoint(x: 40, y: 58))
                    }
                    .stroke(Color.black, lineWidth: 2)
                    
                    // Rosy cheeks
                    HStack(spacing: 30) {
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: 8, height: 6)
                            .opacity(0.3)
                        
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: 8, height: 6)
                            .opacity(0.3)
                    }
                    .offset(y: 5)
                    
                    // Arms reaching up
                    HStack(spacing: 60) {
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addQuadCurve(to: CGPoint(x: -15, y: -35), control: CGPoint(x: -10, y: -15))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 5)
                        
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addQuadCurve(to: CGPoint(x: 15, y: -35), control: CGPoint(x: 10, y: -15))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 5)
                    }
                    .offset(y: -10)
                }
            }
        }
        .frame(width: 120, height: 120)
    }
}

struct SparkleView: View {
    let x: CGFloat
    let y: CGFloat
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        Circle()
            .fill(Color(red: 0.922, green: 1.0, blue: 0.0))
            .frame(width: animate ? 6 : 2, height: animate ? 6 : 2)
            .opacity(animate ? 1.0 : 0.0)
            .position(x: x, y: y)
            .animation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
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