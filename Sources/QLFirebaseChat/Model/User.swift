//
//  User.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import FirebaseFirestoreSwift
import Foundation

public class ChatUser: Codable, ObservableObject {
    @DocumentID public var id: String?
    public var users: [String]?
    public var groupName: String?
    public var messageTitle: String?
    public var receiverName: String?
    public var lastMessage: String?

    public init() {}
}
