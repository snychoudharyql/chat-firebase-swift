//
//  ChatViewModel.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 22/09/23.
//

import Foundation
import QLFirebaseChat
import Firebase


class MessageViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var users = [User]()
    @Published var chatList = [ChatListUser]()
    @Published var initiatedDocumentID = ""
    var collectionType = CollectionType.users
    @Published var messageList = [MessageModel]()
    
    
    // MARK: -  Initiate Chat
    
    func chatInitate(groupName: String, uIDs: [String], callback: @escaping(Bool) -> Void) {
        var chat = [String: Any]()
        chat["users"] = uIDs
        chat["group_name"] = groupName
        chat["id"]  = UUID().uuidString
        chat["time_stamp"] = Timestamp(date: Date())
        FirebaseManager.shared.createGroup(with: chat, id: chat["id"] as! String, collection: .messages) { isSuccess in
            callback(true)
        }
    }
    
    // MARK: - chatInitiateWithMessage
    func chatInitiateWithMessage(uIDs: [String], text: String) {
        var chat = [String: Any]()
        chat["users"] = uIDs
        chat["group_name"] = ""
        chat["id"] = UUID().uuidString
        chat["time_stamp"] = Timestamp(date: Date())
        if let documentID = chat["id"] as? String {
            FirebaseManager.shared.createGroup(with: chat, id: documentID, collection: .messages) { isSuccess in
                if isSuccess {
                    
                    self.message(text: text, documentID: documentID)
                    self.initiatedDocumentID = documentID
                }
                
            }
        }
    }
    
    // MARK: - Chat message
    
    func message(text: String, documentID: String) {
        var message = [String: Any]()
        message["text"] = text
        message["sender_id"]  = FirebaseManager.shared.getCurrentUser(with: .UID)
        message["send_time"] = Timestamp(date: Date())
        FirebaseManager.shared.sendMessage(with: documentID, message: message, type: .message) { isSuccess in
            if isSuccess {
                debugPrint("createdMessage Successfully!!!")
                self.messageList(documentID: documentID)
                
                let dataToUpdate: [String: Any] = [
                    "last_message": text,
                    "time_stamp": Timestamp(date: Date())
                ]

                FirebaseManager.shared.lastMessageUpdate(with: .messages, data: dataToUpdate, documentID: documentID, message: text) { isSuccess in
                    
                }
            }
        }
    }
    
    func messageList(documentID: String) {
        if !documentID.isEmpty {
            FirebaseManager.shared.fetchMessages(with: documentID) { fetchChatList in
                if fetchChatList == nil {
                    self.messageList = []
                } else {
                    DispatchQueue.main.async {
                        if let snapshots = fetchChatList {
                            self.messageList = snapshots.compactMap { queryDocumentSnapshot in
                                do {
                                    let message = try queryDocumentSnapshot.data(as: MessageModel.self)
                                    return message
                                } catch {
                                    debugPrint("Error decoding user: \(error.localizedDescription)")
                                    return nil
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    
    // MARK: - GetUserList
    func getUserList() {
        ContactManager.shared.fetchContacts { fetchUser in
            self.users = fetchUser
            let group = DispatchGroup()
            
            for i in 0..<fetchUser.count {
                group.enter()
                FirebaseManager.shared.getUserDetail(forUID: fetchUser[i].email ?? "", type: .email) { name, uid in
                    fetchUser[i].isOnContact = !(name == nil)
                    fetchUser[i].uid = uid ?? ""
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.users = fetchUser
            }
        }
    }
    
    // MARK: - isMemberChatInitiated
    
    /// Check selected member have any chat with the current
    func isMemberChatInitiated(with uID: String,completion: @escaping ([ChatListUser]?) ->Void){
        FirebaseManager.shared.getIndividualChat(user: uID) { fetchChatList in
            if fetchChatList == nil {
                completion([])
            } else {
                //DispatchQueue.main.async {
                if let snapshots = fetchChatList {
                    var chatMemebers = [ChatListUser]()
                    let group = DispatchGroup()
                    group.enter()
                    chatMemebers = snapshots.compactMap { queryDocumentSnapshot in
                        do {
                            let message = try queryDocumentSnapshot.data(as: ChatListUser.self)
                            if message.users?.count == 2 {
                                return message
                            } else { return nil }
                        } catch {
                            return nil
                        }
                    }
                    group.leave()
                    for i in 0..<chatMemebers.count {
                        group.enter()
                        chatMemebers[i].users?.removeAll { $0 == FirebaseManager.shared.getCurrentUser(with: .UID) }
                        if let firstUserID = chatMemebers[i].users?.first {
                            FirebaseManager.shared.getUserDetail(forUID: firstUserID, type: .UID) { name, _ in
                                if let memberName = name {
                                    chatMemebers[i].receiverName = memberName
                                }
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        completion(chatMemebers) //chatMemebers
                    }
                }
            }
        }
    }
}
