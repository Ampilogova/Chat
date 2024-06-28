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

    var body: some View {
        VStack {
            NavigationView {
                HStack() {
                    ForEach(AIModel.allCases, id: \.self) { model in
                        Button {
                            selectedModel = model
                        } label: {
                            Text(model.title)
                        }
                        .padding()
                        .background(selectedModel == model ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedModel == model ? Color.white : Color.black)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    create()
                }, label: {
                Text("Create")
                }))
            }
        }
    }
    
    private func create() {
    }
}
