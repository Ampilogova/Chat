//
//  CreateChat.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/28/24.
//

import SwiftUI

struct CreateChat: View {
    
    @State private var selectedModel: AIModel?
    @State private var path = NavigationPath()
    @Environment(\.modelContext) var modelContext
    var promptService: PromptService
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    ForEach(AIModel.allCases, id: \.self) { model in
                        Button {
                            selectedModel = model
                        } label: {
                            Text(model.title)
                        }
                        .padding()
                        .background(selectedModel == model ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedModel == model ? Color.white : Color.black)
                        .cornerRadius(8)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                createNewChat()
            }) {
                Text("Create")
            })
            .navigationDestination(for: Chat.self) { chat in
                    ChatUIView(promptService: promptService, chat: chat)
            }
        }
    }
    
    private func createNewChat() {
        if let modelName = selectedModel {
            let chat = Chat(aimodel: modelName.modelName, title: modelName.title)
            modelContext.insert(chat)
            path.append(chat)
        }
    }
}
