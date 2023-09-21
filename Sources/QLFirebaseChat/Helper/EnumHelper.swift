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
    case groupName = "group_name"
}
