//
//  ChatTableViewController.swift
//  Chat
//
//  Created by Tatiana Ampilogova on 6/4/24.
//

import UIKit

class ChatTableViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView = UITableView()
    private let inputContainerView = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    private var messages = [ChatMessage(sender: "Me", prompt: "mvmvmvmvm", isIncoming: false, timestamp: Data()),
                            ChatMessage(sender: "Ollama", prompt: "mvmvmvmvmqweeeeee", isIncoming: true, timestamp: Data())]
    private let promptService: PromptService

    private var inputContainerViewBottomConstraint: NSLayoutConstraint!
    
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
        setupUI()
        sendPrompt()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    func setupUI() {
        // TableView constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
//         InputContainerView constraints
        view.addSubview(inputContainerView)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.backgroundColor = .red
        inputContainerViewBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6)
        NSLayoutConstraint.activate([
            inputContainerView.heightAnchor.constraint(equalToConstant: 50),
            inputContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerViewBottomConstraint
        ])
//        
//        // InputTextField constraints
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        inputContainerView.addSubview(textField)
        textField.backgroundColor = .yellow
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 8),
            textField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, constant: -16)
        ])
      
//        // SendButton constraints
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(sendButton)
        sendButton.backgroundColor = .green
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -8),
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func sendPrompt() {
        promptService.sendPrompt(text: textField.text ?? "") { [weak self] result in
            switch result {
            case.success(let answer):
                DispatchQueue.main.async {
                    self?.messages.append(answer)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let model = messages[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("user started editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("user ended editing")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            inputContainerViewBottomConstraint.constant = -keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputContainerViewBottomConstraint.constant = -6
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
}

