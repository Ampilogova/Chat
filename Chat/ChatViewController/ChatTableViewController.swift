//
//  ChatTableViewController.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/4/24.
//



import UIKit

class ChatTableViewController: UIViewController, UITextFieldDelegate {
    
    private var tableView = UITableView()
    private let inputContainerView = UIView()

    private var messages: [ChatMessage] = []
    private var dataSource: UITableViewDiffableDataSource<String, ChatMessage>!
    private let promptService: PromptService
    
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Message"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
        let largeIcon = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)
        button.setImage(largeIcon, for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    init(promptService: PromptService) {
        self.promptService = promptService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        setupUI()
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
            cell.configure(with: item)
            return cell
        }
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(["main"])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func addMessage(_ message: ChatMessage) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([message])
        dataSource.apply(snapshot, animatingDifferences: true)
        scrollToBottom()
    }
    
    func setupUI() {
        view.addSubview(inputContainerView)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputContainerView.heightAnchor.constraint(equalToConstant: 50),
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor)
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        inputContainerView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 8),
            textField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, constant: -16)
        ])
      
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -4),
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 4),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func sendButtonTapped() {
        sendRequest(prompt: textField.text ?? "")
        addMessage(ChatMessage(isIncoming: false, response: textField.text ?? ""))
        textField.text = ""
        scrollToBottom()
    }
    
    private func sendRequest(prompt: String) {
        Task {
            do {
                let answer = try await promptService.sendPrompt(text: prompt)
                DispatchQueue.main.async { [weak self] in
                    self?.addMessage(answer)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}


