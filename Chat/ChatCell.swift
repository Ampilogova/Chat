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
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
        // Set up constraints for the messageLabel
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        // Set up constraints for the bubbleBackgroundView
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8).isActive = true
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8).isActive = true
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8).isActive = true
        
        // Set up dynamic left and right anchors
        bubbleLeftAnchor = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        bubbleRightAnchor = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.response
        if message.isIncoming {
            bubbleBackgroundView.backgroundColor = .systemGray5
            messageLabel.textColor = .black
            bubbleLeftAnchor.isActive = true
            bubbleRightAnchor.isActive = false
        } else {
            bubbleBackgroundView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            bubbleLeftAnchor.isActive = false
            bubbleRightAnchor.isActive = true
        }
        
    }
}
