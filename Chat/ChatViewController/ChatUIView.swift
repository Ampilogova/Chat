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
    
    @Query var messages: [ChatMessage]
    @State private var newMessage: String = ""
    @State private var path = [ChatMessage]()
    
    @Environment(\.modelContext) var modelContext
    var promptService: PromptService
    
    var body: some View {
        NavigationView {
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
                         scrollToBottom(scrollViewProxy: scrollViewProxy)
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
            .navigationTitle("Ollama")
            .navigationBarTitleDisplayMode(.inline)
        }
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
                let answer = try await promptService.sendPrompt(text: prompt)
                let message = ChatMessage(isIncoming: true, text: answer.text)
                modelContext.insert(message)
                path.append(message)
            } catch {
                print("Failed to send request: \(error)")
            }
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else {
            return
        }
        let newChatMessage = ChatMessage(isIncoming: false, text: newMessage)
        modelContext.insert(newChatMessage)
        path.append(newChatMessage)
        sendRequest(prompt: newMessage)
        newMessage = ""
    }
}

#Preview {
    ChatUIView(promptService: PromptServiceImpl(networkService: NetworkServiceImpl()))
}
