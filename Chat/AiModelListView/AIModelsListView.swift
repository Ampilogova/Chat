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
    @Query private var chats: [Chat]
    @State private var showModal = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chats) { chat in
                    NavigationLink(destination: ChatUIView(promptService: promptService, chat: chat)) {
                        Text(chat.title)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing: Button(action: {
                showModal = true
            }, label: {
                Image(systemName: "plus")
            }))
            .popover(isPresented: $showModal, content: {
                CreateChat(promptService: promptService)
            })
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let chat = chats[index]
            modelContext.delete(chat)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error deleting chat: \(error)")
        }
    }
}
