//
//  User.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import Foundation
import QLFirebaseChat
import FirebaseFirestoreSwift

class User: Codable, ObservableObject {
    @DocumentID var id: String?
    var uid: String?
    var name: String?
    var email: String?
    var isOnContact: Bool?
}


class ChatListUser: Codable, ObservableObject {
    @DocumentID var id: String?
    var users: [String]?
    var groupName: String?
    var messageTitle: String?
    var receiverName: String?
}
