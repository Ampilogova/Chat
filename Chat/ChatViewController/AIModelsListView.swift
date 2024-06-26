//
//  AIListUIView.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/23/24.
//

import SwiftUI
    
    struct AIModelsListView: View {
        var promptService: PromptService
        
        var body: some View {
            NavigationView {
                List(AIModel.allCases, id: \.self) { model in
                    NavigationLink(destination: ChatUIView(promptService: promptService, title: model.modelName, chatId: model.modelName)) {
                        Text(model.title)
                    }
                }
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
