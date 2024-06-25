//
//  AIListUIView.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/23/24.
//

import SwiftUI

struct AIListUIView: View {
    var promptService: PromptService
    var dict = ["gemma:2b": "Gemma", "tinyllama": "Tiny Llama"]
    
    var body: some View {
        NavigationView {
            List(dict.keys.sorted(), id: \.self) { key in
                if let value = dict[key] {
                    NavigationLink(
                        destination: ChatUIView(
                            promptService: promptService,
                            title: value,
                            chatId: key
                        )
                    ) {
                        Text(value)
                    }
                }
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.automatic)
            .background(Color.white) // Ensure background color is applied to NavigationView
        }
    }
}
