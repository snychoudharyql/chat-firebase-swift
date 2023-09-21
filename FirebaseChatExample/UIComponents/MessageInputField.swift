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
    @StateObject var messagesManager: UserViewModel
    @State private var message = ""
    @Binding var documentID: String
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
            .frame(height: 52)
            .disableAutocorrection(true)
    }
    
    private var sendButton: some View {
        Button(action: sendMessage) {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.white)
                .padding(10)
                .background(Color("Peach"))
                .cornerRadius(50)
        }
    }
    
    private func sendMessage() {
        if !documentID.isEmpty {
            messagesManager.message(text: message, documentID: documentID)
        } else if !messagesManager.initiatedDocumentID.isEmpty {
            messagesManager.message(text: message, documentID: messagesManager.initiatedDocumentID)
        } else {
            messagesManager.chatInitiateWithMessage(uIDs: [FirebaseManager.shared.getCurrentUser(), receiverID], text: message)
        }
        message = ""
    }
    
    // MARK: - Lifecycle
    
    init(messagesManager: UserViewModel, documentID: Binding<String>, receiverID: String) {
        self._messagesManager = StateObject(wrappedValue: messagesManager)
        self._documentID = documentID
        self.receiverID = receiverID
    }
    
    // MARK: - View Modifier
    
    func backgroundStyle(_ color: Color) -> some View {
        background(color)
    }
}
