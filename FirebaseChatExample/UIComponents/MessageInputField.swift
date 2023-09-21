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
    @ObservedObject var messagesManager: UserViewModel
    @State private var message = ""
    var documentID: String
    var receiverEmail = ""
    
    // MARK: - body
    
    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                if !documentID.isEmpty {
                    messagesManager.message(text: message, documentID: documentID)
                } else {
                
                    messagesManager.chatInitiateWithMessage(uIDs: [FirebaseManager.shared.getCurrentUser(), receiverEmail], text: message)
                }
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("Peach"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
        
        
    }
}

struct MessageInputField_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputField(messagesManager: UserViewModel(), documentID: "")
    }
}
