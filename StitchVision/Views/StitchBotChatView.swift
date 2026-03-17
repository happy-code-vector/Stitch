import SwiftUI

struct StitchBotChatView: View {
    @StateObject private var service = StitchBotService.shared
    @StateObject private var subscription = SubscriptionManager.shared
    @State private var inputText = ""
    @State private var showPaywall = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Usage indicator (Free tier only)
                if !subscription.isPro {
                    usageIndicator
                }

                // Messages
                messagesView

                // Input area
                inputArea
            }
            .background(Color(red: 0.976, green: 0.969, blue: 0.949))
            .navigationTitle("Ask StitchBot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !service.messages.isEmpty {
                        Button("Clear") {
                            service.clearConversation()
                        }
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(feature: "Unlimited AI Chat")
            }
        }
    }

    // MARK: - Usage Indicator

    private var usageIndicator: some View {
        HStack {
            Image(systemName: "bubble.left.and.bubble.right")
                .foregroundColor(service.questionsRemaining <= 3 ? .orange : Color(red: 0.561, green: 0.659, blue: 0.533))

            Text(service.questionsRemaining > 0
                 ? "\(service.questionsRemaining) questions left this month"
                 : "No questions remaining")
                .font(.caption)
                .foregroundColor(service.questionsRemaining <= 3 ? .orange : Color(red: 0.4, green: 0.4, blue: 0.4))

            Spacer()

            if service.questionsRemaining <= 3 {
                Button("Upgrade") {
                    showPaywall = true
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }

    // MARK: - Messages View

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if service.messages.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(service.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        if service.isLoading {
                            HStack {
                                ProgressView()
                                    .padding()
                                Text("StitchBot is thinking...")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
            .onChange(of: service.messages.count) { _ in
                if let lastMessage = service.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))

            Text("Ask me anything about knitting or crochet!")
                .font(.headline)
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 12) {
                suggestionButton("How do I do a yarn over?")
                suggestionButton("What's the difference between k2tog and ssk?")
                suggestionButton("Help me fix a dropped stitch")
                suggestionButton("Best yarn for beginner scarves?")
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
    }

    private func suggestionButton(_ text: String) -> some View {
        Button {
            inputText = text
            Task {
                await sendMessage()
            }
        } label: {
            HStack {
                Image(systemName: "sparkle")
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
        }
    }

    // MARK: - Input Area

    private var inputArea: some View {
        VStack(spacing: 0) {
            if let error = service.errorMessage {
                errorBanner(error)
            }

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Ask about knitting or crochet...", text: $inputText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(20)
                    .focused($isInputFocused)
                    .lineLimit(1...5)
                    .disabled(service.isLoading)
                    .onSubmit {
                        Task {
                            await sendMessage()
                        }
                    }

                Button {
                    Task {
                        await sendMessage()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(inputText.isEmpty || service.isLoading
                                  ? Color(red: 0.8, green: 0.8, blue: 0.8)
                                  : Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 44, height: 44)

                        if service.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(inputText.isEmpty || service.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -2)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            Text(message)
                .font(.caption)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))

            Spacer()

            Button("Upgrade") {
                showPaywall = true
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(red: 1.0, green: 0.95, blue: 0.85))
    }

    // MARK: - Actions

    private func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""
        await service.sendMessage(text)
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left.fill")
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        Text("StitchBot")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }

                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(message.isUser ? .white : Color(red: 0.2, green: 0.2, blue: 0.2))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.isUser
                            ? Color(red: 0.561, green: 0.659, blue: 0.533)
                            : Color.white
                    )
                    .cornerRadius(16)
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    StitchBotChatView()
}
