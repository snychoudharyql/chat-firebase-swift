//
//  EnumHelper.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 15/09/23.
//

import Foundation
import SwiftUI

/// CollectionType:  All collections
public enum CollectionType: String {
    case users
    case messages
    case message
}

/// FieldType :  All attributes
public enum FieldType: String {
    case id
    case users
    case email
    case text
    case UID = "uid"
    case groupName = "group_name"
    case name
}

/// Expandable EditBox :  Return the slection type in it
public enum EditBoxSelectionType {
    case send
    case addMedia([UIImage])
}

/// ContentType: Used for create folder with Images or Videos name
public enum ContentType: String {
    case image = "Images"
    case video = "Videos"
}

/// PhotoSourceType: Used for to check source type of image picker
public enum PhotoSourceType {
    case camera
    case gallery
}
