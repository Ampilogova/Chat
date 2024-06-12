//
//  ChatCell.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/11/24.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bubbleBackgroundView)
        contentView.addSubview(messageLabel)
        
        // Message Label Constraints
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        // Bubble Background View Constraints
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8)
        ])
        
        // Dynamic width constraint
        bubbleWidthAnchor = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        bubbleWidthAnchor.isActive = true
        
        // Dynamic leading/trailing constraints
        bubbleLeftAnchor = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        bubbleRightAnchor = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.prompt
        
        if message.isIncoming {
            bubbleBackgroundView.backgroundColor = .systemGray5
            bubbleLeftAnchor.isActive = true
            bubbleRightAnchor.isActive = false
        } else {
            bubbleBackgroundView.backgroundColor = .systemBlue
            bubbleLeftAnchor.isActive = false
            bubbleRightAnchor.isActive = true
        }
    }
}
