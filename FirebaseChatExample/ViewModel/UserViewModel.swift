//
//  UserViewModel.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Foundation
import QLFirebaseChat
import Firebase
import FirebaseFirestore

class UserViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var userName = ""
    @Published var userEmailID = ""
    @Published var userPassword = ""
    @Published var isUserSuccessfulLogin = false
    @Published var isChatInitiated = false
    @Published var users = [User]()
    @Published var chatList = [ChatListUser]()
    @Published var isLoading = false
    @Published var errorMessage = ErrorMesaage()
    @Published var messageList = [MessageModel]()
    @Published var initiatedDocumentID = ""
    var collectionType = CollectionType.users

    //MARK: User Login
    func loginUser(email: String, password: String) {
        isLoading = true
        FirebaseAuthManager.shared.loginUser(email: email, password: password) { result in
            self.isLoading = false
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: userStatus)
            case .failure(let failure):
                self.errorMessage.message = failure.localizedDescription
                self.errorMessage.isError = true
            }
        }
    }
    
    //MARK: - Register User
    func registerUser(email: String, password: String) {
        isLoading = true
        FirebaseAuthManager.shared.registerUser(email: email, password: password) { result in
            self.isLoading  = false
            switch result {
            case .success(let user):
                self.isUserSuccessfulLogin = true
                UserDefaults.standard.set(true, forKey: userStatus)
                self.createNewUser(with: user.uid)
                
            case .failure(let failure):
                self.errorMessage.message = failure.localizedDescription
                self.errorMessage.isError = true
                debugPrint("Register Failure:", failure)
            }
        }
    }
    
    //MARK: - Create New User
    func createNewUser(with userId: String) {
        var user  = [String: Any]()
        user["name"] = userName
        user["email"] = userEmailID
        user["uid"]  = userId
        FirebaseManager.shared.addNewUser(with: user, id: userId, collection: .users) { isSuccess in
            self.isUserSuccessfulLogin = isSuccess
        }
    }
    
    // MARK: - GetUserList
    func getUserList() {
        ContactManager.shared.fetchContacts { fetchUser in
            self.users = fetchUser
        }
    }
    
    // MARK: Get Chat List
    
    func getChatList() {
        FirebaseManager.shared.fetchChatList(with: "messages") { fetchChatList in
            if fetchChatList == nil {
                self.chatList = []
            } else {
                //DispatchQueue.main.async {
                    if let snapshots = fetchChatList {
                        var chatMemebers = [ChatListUser]()
                        let group = DispatchGroup()
                        group.enter()
                        chatMemebers = snapshots.compactMap { queryDocumentSnapshot in
                            do {
                                let message = try queryDocumentSnapshot.data(as: ChatListUser.self)
                                return message
                            } catch {
                                return nil
                            }
                        }
                        group.leave()
                        for i in 0..<chatMemebers.count {
                            group.enter()
                            if chatMemebers[i].users?.count == 2 {
                                chatMemebers[i].users?.removeAll { $0 == FirebaseManager.shared.getCurrentUser() }
                                if let firstUserID = chatMemebers[i].users?.first {
                                    print("appearance: ", i)
                                    FirebaseManager.shared.getUserName(forUID: firstUserID) { name in
                                        if let memberName = name {
                                            chatMemebers[i].receiverName = memberName
                                        }
                                        group.leave()
                                    }
                                }
                            }else {
                                chatMemebers[i].receiverName = chatMemebers[i].groupName
                                group.leave()
                            }
                        }
                       
                        group.notify(queue: .main) {
                            self.chatList = chatMemebers
                    }
                
                }

            }
        }
    }
    
    // MARK: -  Initiate Chat
    
    func chatInitate(groupName: String, uIDs: [String], callback: @escaping(Bool) -> Void) {
        var chat = [String: Any]()
        chat["users"] = uIDs
        chat["groupName"] = groupName
        chat["id"]  = UUID().uuidString
        FirebaseManager.shared.createGroup(with: chat, id: chat["id"] as! String, collection: .messages) { isSuccess in
            callback(true)
        }
    }
    
    // MARK: - chatInitiateWithMessage
    func chatInitiateWithMessage(uIDs: [String], text: String) {
        var chat = [String: Any]()
        chat["users"] = uIDs
        chat["groupName"] = ""
        chat["id"]  = UUID().uuidString
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
        message["sender_id"]  = FirebaseManager.shared.getCurrentUser()
        message["send_time"] =  Timestamp(date: Date())
        FirebaseManager.shared.sendMessage(with: documentID, message: message, type: .message) { isSuccess in
            if isSuccess {
                debugPrint("createdMessage Successfully!!!")
                self.messageList(documentID: documentID)
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
    
    // MARK: - isMemberChatInitiated
    
    /// Check selected member have any chat with the curre
    func isMemberChatInitiated(with uID: String,completion: @escaping ([ChatListUser]?) ->Void){
        FirebaseManager.shared.getIndividualChat(users: [FirebaseManager.shared.getCurrentUser(),uID]) { fetchChatList in
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
                            chatMemebers[i].users?.removeAll { $0 == FirebaseManager.shared.getCurrentUser() }
                            if let firstUserID = chatMemebers[i].users?.first {
                                FirebaseManager.shared.getUserName(forUID: firstUserID) { name in
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
