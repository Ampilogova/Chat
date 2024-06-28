//
//  AIListUIView.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/23/24.
//

import SwiftUI
    
    struct AIModelsListView: View {
        var promptService: PromptService
        @State private var showModal = false
        
        var body: some View {
            NavigationView {
                List(AIModel.allCases, id: \.self) { model in
                    NavigationLink(destination: ChatUIView(promptService: promptService, title: model.title, chatId: model.modelName)) {
                        Text(model.title)
                    }
                    .navigationBarItems(trailing: Button(action: {
                        showModal = true
                    }, label: {
                        Image(systemName: "plus")
                    }))
                }
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.automatic)
            }
            .sheet(isPresented: $showModal) {
                CreateChat()
                    .presentationDetents([.height(300)])
            }
        }
    }
