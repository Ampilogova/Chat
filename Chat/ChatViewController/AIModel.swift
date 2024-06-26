//
//  AIModel.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/26/24.
//

import UIKit

enum AIModel: CaseIterable {
    
    case gemma
    case tinyllama
    
    var title: String {
        switch self {
        case .gemma: return "Gemma"
        case .tinyllama: return "Tiny Llama"
        }
    }
    
    var modelName: String {
        switch self {
        case .gemma: return "gemma:2b"
        case .tinyllama: return "tinyllama"
        }
    }
}
