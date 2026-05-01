import SwiftUI

struct StitchBotChatView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var service = StitchBotService.shared
    @StateObject private var subscription = SubscriptionManager.shared
    @State private var inputText = ""
    @State private var showPaywall = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages
                messagesView

                // Input area
                inputArea
            }
            .background(ThemeColors.background)
            .navigationTitle("Ask StitchBot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { appState.goBack() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                }
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
                                    .foregroundColor(ThemeColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
            .onChange(of: service.messages.count) { _, _ in
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
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(ThemeColors.textSecondary)

            Text("Ask me anything about knitting or crochet!")
                .font(.headline)
                .foregroundColor(ThemeColors.textPrimary)
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
                    .foregroundColor(ThemeColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ThemeColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(ThemeColors.surface)
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
                    .background(ThemeColors.surface)
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
                                  ? ThemeColors.border
                                  : ThemeColors.primary)
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
            .background(ThemeColors.surface)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -2)

            if !subscription.isPro {
                HStack {
                    Text("\(service.questionsRemaining) free questions remaining this month · Upgrade for unlimited")
                        .font(.system(size: 11))
                        .foregroundColor(ThemeColors.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
    }

    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            Text(message)
                .font(.caption)
                .foregroundColor(ThemeColors.textSecondary)

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
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                }

                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(message.isUser ? .white : ThemeColors.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.isUser
                            ? ThemeColors.primary
                            : ThemeColors.surface
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
