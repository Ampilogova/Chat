//
//  ChatUIView.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/21/24.
//

import SwiftUI
import UIKit
import SwiftData

struct ChatUIView: View {
    
    @Query private var messages: [ChatMessage]
    @State private var newMessageText: String = ""
    @Environment(\.modelContext) var modelContext
    
    var promptService: PromptService
    var chat: Chat
    
    init(promptService: PromptService, chat: Chat) {
        self.promptService = promptService
        self.chat = chat
        let chatId = chat.persistentModelID
        self._messages = Query(filter: #Predicate { $0.chat.persistentModelID == chatId })
    }
    
    var messageList: some View {
        VStack {
            ForEach(messages) { item in
                ChatCell(message: item)
                    .id(item.id)
            }
        }
    }
    
    @ViewBuilder var messageInputView: some View {
        HStack {
            TextField("Enter message", text: $newMessageText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5)
            
            Button(action: {
                sendMessage()
            }) {
                Text("Send")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(newMessageText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(newMessageText.isEmpty)
        }
        .padding()
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    messageList
                }
                .onChange(of: messages) { _, _ in
                    createSubtitle()
                    scrollToBottom(scrollViewProxy: scrollViewProxy)
                }
                .onAppear {
                    createSubtitle()
                    if let lastMessage = messages.last {
                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            messageInputView
        }
        .navigationBarTitle(chat.title, displayMode: .inline)
    }
    
    
    private func scrollToBottom(scrollViewProxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    private func sendRequest(prompt: String) {
        Task {
            do {
                let answer = try await promptService.sendPrompt(text: prompt, modelName: chat.AIModel)
                let message = ChatMessage(isIncoming: true, text: answer, chat: chat)
                modelContext.insert(message)
            } catch {
                print("Failed to send request: \(error)")
            }
        }
    }
    
    private func sendMessage() {
        let prevMessaages = makeAISmart()
        let newChatMessage = ChatMessage(isIncoming: false, text: newMessageText, chat: chat)
        modelContext.insert(newChatMessage)
        sendRequest(prompt: prevMessaages + newMessageText)
        newMessageText = ""
    }
    
    private func makeAISmart() -> String {
        var request = ""
        for message in messages {
            if !message.isIncoming {
                request += message.text
            }
        }
        return request
    }
    private func createSubtitle() {
        if let subtitle = messages.first?.text {
            chat.subtitle = subtitle
        }
    }
    
    func deleteAllData() {
        do {
            try modelContext.delete(model: ChatMessage.self)
        } catch {
            print("Failed to delete all schools.")
        }
    }
}
