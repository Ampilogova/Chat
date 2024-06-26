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
    var title: String
    var chatId: String
    
    init(promptService: PromptService, title: String, chatId: String) {
        self.promptService = promptService
        self.title = title
        self.chatId = chatId
        self._messages = Query(filter: #Predicate { $0.chatId == chatId })
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
                    scrollToBottom(scrollViewProxy: scrollViewProxy)
                }
                .onAppear {
                    if let lastMessage = messages.last {
                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            messageInputView
        }
        .navigationBarTitle(title, displayMode: .inline)
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
                let answer = try await promptService.sendPrompt(text: prompt, modelName: chatId)
                let message = ChatMessage(isIncoming: true, text: answer.text, chatId: chatId)
                modelContext.insert(message)
            } catch {
                print("Failed to send request: \(error)")
            }
        }
    }
    
    private func sendMessage() {
        let newChatMessage = ChatMessage(isIncoming: false, text: newMessageText, chatId: chatId)
        modelContext.insert(newChatMessage)
        sendRequest(prompt: newMessageText)
        newMessageText = ""
    }
    
    func deleteAllData() {
        do {
            try modelContext.delete(model: ChatMessage.self)
        } catch {
            print("Failed to delete all schools.")
        }
    }
}
