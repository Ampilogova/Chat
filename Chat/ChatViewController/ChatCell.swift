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
    
    let incomingBubbleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gray_tail"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let outgoingBubbleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "blue_tail"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(incomingBubbleImage)
        addSubview(outgoingBubbleImage)
        
        // Set up constraints for the messageLabel
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        // Set up constraints for the bubbleBackgroundView
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12)
        ])
        
        // Set up constraints for the tail images
        NSLayoutConstraint.activate([
            incomingBubbleImage.trailingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 15),
            incomingBubbleImage.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
            
            outgoingBubbleImage.leadingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -15),
            outgoingBubbleImage.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
        ])
        // Set up dynamic left and right anchors
        bubbleLeftAnchor = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        bubbleRightAnchor = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
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
            incomingBubbleImage.isHidden = false
            outgoingBubbleImage.isHidden = true
        } else {
            bubbleBackgroundView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            bubbleLeftAnchor.isActive = false
            bubbleRightAnchor.isActive = true
            incomingBubbleImage.isHidden = true
            outgoingBubbleImage.isHidden = false
        }
    }
}
