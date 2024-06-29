//
//  CreateChat.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/28/24.
//

import SwiftUI

struct CreateChat: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedModel: AIModel? = nil
    @State private var path = NavigationPath()
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
            .navigationDestination(for: AIModel.self) { model in
                ChatUIView(promptService: promptService, title: model.title, chatId: model.modelName)
            }
        }
    }
    
    private func createNewChat() {
        if let model = selectedModel {
            path.append(model)
        } else {
            // Handle the case when no model is selected, e.g., show an alert
            print("No model selected")
        }
    }
}
