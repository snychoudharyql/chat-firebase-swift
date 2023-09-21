//
//  MessageInputField.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct MessageInputField: View {
    @ObservedObject var messagesManager: UserViewModel
    @State private var message = ""
    var documentID: String

    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                messagesManager.message(text: message, documentID: documentID)
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
