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
        FirebaseManager.shared.fetchChatList(with: .messages) { [weak self] fetchChatList in
            guard let self else { return }

            if let snapshots = fetchChatList {
                var chatMembers = [ChatUser]()
                let group = DispatchGroup()

                for snapshot in snapshots {
                    group.enter()

                    if let message = try? snapshot.data(as: ChatUser.self) {
                        chatMembers.append(message)

                        if message.users?.count == 2 {
                            message.users?.removeAll { $0 == FirebaseManager.shared.getCurrentUser(with: .UID) }
                            if let firstUserID = message.users?.first {
                                group.enter()
                                FirebaseManager.shared.getUserDetail(forUID: firstUserID, type: .UID) { name, _ in
                                    if let memberName = name {
                                        message.receiverName = memberName
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            message.receiverName = message.groupName
                        }
                    }

                    group.leave()
                }

                group.notify(queue: .main) {
                    self.chatList = chatMembers
                }
            } else {
                self.chatList = []
            }
        }
    }
}
