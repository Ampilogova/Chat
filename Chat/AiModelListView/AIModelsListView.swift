//
//  AIListUIView.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/23/24.
//

import SwiftUI
import SwiftData

struct AIModelsListView: View {
    var promptService: PromptService
    //    var chats =  [AIModel]()
    @Query private var chats: [Chat]
    @State private var showModal = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatUIView(promptService: promptService, chat: chat)) {
                    Text(chat.id.uuidString)
                }
                
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.automatic)
                
            }
            .navigationBarItems(trailing: Button(action: {
                                    showModal = true
//                let chat = Chat(aimodel: AIModel.tinyllama.modelName)
//                modelContext.insert(chat)
            }, label: {
                Image(systemName: "plus")
            }))
            
            .popover(isPresented: $showModal, content: {
                CreateChat(promptService: promptService)
            })
        }
        
    }
}
