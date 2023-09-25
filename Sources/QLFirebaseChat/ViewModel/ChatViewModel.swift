//
//  ChatViewModel.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 22/09/23.
//

import Firebase
import Foundation
import SwiftUI

public class ChatViewModel: ObservableObject {
    // MARK: - Properties

    @Published var users = [User]()
    @Published var chatList = [ChatUser]()
    @Published var initiatedDocumentID = ""
    var collectionType = CollectionType.users

    /// Customize properties of UI
    let headerBackgroundColor: Color
    let headerTitle: String
    let addGroupIcon: String
    let headerForegroundColor: Color

    // MARK: Initialization

    public init(title: String, headerBackgroundColor: Color, iconName: String, headerForegroundColor: Color = .black) {
        self.headerBackgroundColor = headerBackgroundColor
        headerTitle = title
        addGroupIcon = iconName
        self.headerForegroundColor = headerForegroundColor
    }

    // MARK: Get Chat List

    public func getChatList() {
        FirebaseManager.shared.fetchChatList(with: .messages) { fetchChatList in
            if fetchChatList == nil {
                self.chatList = []
            } else {
                if let snapshots = fetchChatList {
                    var chatMemebers = [ChatUser]()
                    let group = DispatchGroup()
                    group.enter()
                    chatMemebers = snapshots.compactMap { queryDocumentSnapshot in
                        do {
                            let message = try queryDocumentSnapshot.data(as: ChatUser.self)
                            return message
                        } catch {
                            return nil
                        }
                    }
                    group.leave()
                    for i in 0 ..< chatMemebers.count {
                        group.enter()
                        if chatMemebers[i].users?.count == 2 {
                            chatMemebers[i].users?.removeAll { $0 == FirebaseManager.shared.getCurrentUser(with: .UID) }
                            if let firstUserID = chatMemebers[i].users?.first {
                                FirebaseManager.shared.getUserDetail(forUID: firstUserID, type: .UID) { name, _ in
                                    if let memberName = name {
                                        chatMemebers[i].receiverName = memberName
                                    }
                                    group.leave()
                                }
                            }
                        } else {
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
}
