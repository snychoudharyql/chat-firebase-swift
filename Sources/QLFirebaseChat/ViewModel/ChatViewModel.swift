//
//  ChatViewModel.swift
//
//  Created by Abhishek Pandey on 26/09/23.
//

import Firebase
import Foundation
import SwiftUI

public class ChatViewModel: ObservableObject {
    // MARK: - Properties

    @Published var userChatList: [ChatUser]
    @Published var initiatedDocumentID = ""
    var collectionType = CollectionType.users

    /// Customize properties of UI
    let navigationBarBackgroundColor: Color
    let navigationBarTitle: String
    let navigationBarRightButtonImage: String
    let navigationBarTitleForegroundColor: Color
    let navigationBarTitleFont: Font

    // MARK: Initialization

    public init(userChatList: [ChatUser] = [ChatUser](), initiatedDocumentID: String = "", collectionType: CollectionType = CollectionType.users, navigationBarBackgroundColor: Color, navigationBarTitle: String, navigationBarRightButtonImage: String, navigationBarTitleForegroundColor: Color, navigationBarTitleFont: Font) {
        self.userChatList = userChatList
        self.initiatedDocumentID = initiatedDocumentID
        self.collectionType = collectionType
        self.navigationBarBackgroundColor = navigationBarBackgroundColor
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarRightButtonImage = navigationBarRightButtonImage
        self.navigationBarTitleForegroundColor = navigationBarTitleForegroundColor
        self.navigationBarTitleFont = navigationBarTitleFont
    }

    // MARK: Get Chat List

    public func getUserChatList() {
        QLFirebaseManager.shared.fetchChatList(with: .messages) { [weak self] fetchChatList in
            guard let self else { return }
            if let snapshots = fetchChatList {
                var chatMembers = [ChatUser]()
                let group = DispatchGroup()

                for snapshot in snapshots {
                    group.enter()

                    if let message = try? snapshot.data(as: ChatUser.self) {
                        chatMembers.append(message)

                        if message.users?.count == 2 {
                            message.users?.removeAll { $0 == QLFirebaseManager.shared.getLoggedInUserDetails(with: .UID) }
                            if let firstUserID = message.users?.first {
                                group.enter()
                                QLFirebaseManager.shared.getChatUserDetail(with: firstUserID, type: .UID) { name, _ in
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
                    self.userChatList = chatMembers
                }
            } else {
                self.userChatList = []
            }
        }
    }
}
