//
//  MessageInputField.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat


struct MessageInputField: View {
    
    // MARK: - Properties
    @StateObject var messagesManager: MessageViewModel
    @State private var message = ""
     var documentID = ""
    var receiverID = ""
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            messageTextField
            sendButton
        }
        .padding()
        .background(Color("Gray"))
        .cornerRadius(50)
    }
    
    private var messageTextField: some View {
        CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            .disableAutocorrection(true)
    }
    
    private var sendButton: some View {
        Button {
            if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                sendMessage()
            }
        } label: {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.white)
                .padding(10)
                .background( message.isEmpty ? Color("Peach") : .pink)
                .cornerRadius(50)
        }

    }
    
    private func sendMessage() {
        if !documentID.isEmpty {
            messagesManager.message(text: message, documentID: documentID)
        } else if !messagesManager.initiatedDocumentID.isEmpty {
            messagesManager.message(text: message, documentID: messagesManager.initiatedDocumentID)
        } else {
            messagesManager.chatInitiateWithMessage(uIDs: [FirebaseManager.shared.getCurrentUser(with: .UID), receiverID], text: message)
        }
        message = ""
    }
    
    // MARK: - Lifecycle
    
    init(messagesManager: MessageViewModel, documentID: String, receiverID: String) {
        self._messagesManager = StateObject(wrappedValue: messagesManager)
        self.documentID = documentID
        self.receiverID = receiverID
    }
    
    // MARK: - View Modifier
    
    func backgroundStyle(_ color: Color) -> some View {
        background(color)
    }
}
