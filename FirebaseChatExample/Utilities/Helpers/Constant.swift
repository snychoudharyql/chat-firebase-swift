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


