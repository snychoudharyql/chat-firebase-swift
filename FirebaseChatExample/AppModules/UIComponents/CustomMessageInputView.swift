//
//  MessageInputField.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat


struct CustomMessageInputView: View {
    
    // MARK: - Properties
    @StateObject var messagesManager: MessageViewModel
    @State private var message = ""
    var documentID = ""
    var receiverID = ""
    @State var textLine = 1
    var chatVM = ChatEditBoxVM(isNeedMediaShare: true, sendButtonImage: Image(systemName: "paperplane.fill"), addMediaButtonImage: Image("add_icon"), emptyFieldPlaceholder: "Enter the message", editFieldBackgroundColor: Color(Colors.peach).opacity(0.3), editFieldForegroundColor: .black, editFieldFont: Font.system(size: 15))
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center) {
            ChatEditBoxView(chatEditVM: chatVM, text: $message, imageSelectionType: .single) { type in
                switch type {
                case .addMedia(let images):
                    messagesManager.sendMedia(images: images, documentID: documentID, contentType: .image)
                case .send:
                    sendMessage()
                    
                }
            }
        }
    }
    
    // MARK: Send Message
    private func sendMessage() {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
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
}
