//
//  ChatCell.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/21/24.
//

import SwiftUI

struct ChatCell: View {
    
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isIncoming {
                Text(message.text)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            } else {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal)
    }
}
