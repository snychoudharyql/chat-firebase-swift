//
//  EnumHelper.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import Foundation

public enum CollectionType: String {
    case users
    case messages
    case message
}

public enum FieldType: String {
    case id
    case users
    case email
    case text
    case UID = "uid"
    case groupName = "group_name"
    case name
}

public enum EditBoxSelectionType {
    case send
    case addMedia
}

public enum ContentType: String {
    case image = "Images"
    case video = "Videos"
}
