//
//  User.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import FirebaseFirestoreSwift
import Foundation

class ChatUser: Codable, ObservableObject {
    @DocumentID var id: String?
    var users: [String]?
    var groupName: String?
    var messageTitle: String?
    var receiverName: String?
    var lastMessage: String?
}
