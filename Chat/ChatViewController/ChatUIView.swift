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
    @State private var newMessage: String = ""
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

    var body: some View {
            VStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack {
                            ForEach(messages) { item in
                                ChatCell(message: item)
                                    .id(item.id)
                            }
                        }
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
                HStack {
                    TextField("Enter message", text: $newMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5)
                    Button(action: {
                        sendMessage()
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
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
                let answer = try await promptService.sendPrompt(text: prompt, chatId: chatId)
                let message = ChatMessage(isIncoming: true, text: answer.text, chatId: chatId)
                modelContext.insert(message)
            } catch {
                print("Failed to send request: \(error)")
            }
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else {
            return
        }
        let newChatMessage = ChatMessage(isIncoming: false, text: newMessage, chatId: chatId)
        modelContext.insert(newChatMessage)
        try? modelContext.save()
        sendRequest(prompt: newMessage)
        newMessage = ""
    }
    
    func deleteAllData() {
        do {
            try modelContext.delete(model: ChatMessage.self)
        } catch {
            print("Failed to delete all schools.")
        }
    }
}
