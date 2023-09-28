//
//  Constant.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import Foundation
import SwiftUI

struct Colors {
    static let peach = "Peach"
}


let userStatus = "USER_STATUS"
let kBackButton = "back"
let kAddMember = "addMember"
let kProfile = "profile"
let kAddGroup = "plus_icon"


let kMessages = "messages"
let kUsers = "users"
let kUID = "uid"
let kMessage = "message"
let kSendTime = "send_time"
let kName = "name"
let kEmail = "email"
let kInvite = "Invite"
let kUserTitle = "User List"
let kLibrary = "Choose from Library"
let kPhoto = "Take Photo"
let kActionSheetTitle = "Select a Photo"
let kImagePlaceHolder = "image_placeholder"

public enum ChatList {
    static var heading = "Message"
    static var addMemberImageName = "add_icon"
    static var headerBackgroundColor = Color.green
}

let bottomTitle =  {(isLogin: Bool) in
    return isLogin ? "Create new account" : "Already have account?"
    
}

let buttonTitle =  {(isLogin: Bool) in
    return isLogin ? "Login" : "SignUp"
    
}

let groupButtonTittle = {(isMemberSelected: Bool) in
    return isMemberSelected ? "Remove" : "Create Group Chat"
}

enum MessageType {
    case initiated
    case partial
}



public enum Size {
    static var twenty = 20.0
    static var ten = 10.0
    static var fifteen = 15.0
    static var thirtyFive = 35.0
    static var twentyFour = 24.0
    static var fifty = 50.0
    static var twentyTwo = 22.0
    static var forty = 40.0
    static var chatboxWidth = 280.0
}

public enum EditBoxSelectionType {
    case send
    case addMedia([UIImage])
}

enum PhotoSourceType {
    case camera
    case gallery
}

public enum ImagePickerSelectType {
    case single
    case multiple
    case none
}
