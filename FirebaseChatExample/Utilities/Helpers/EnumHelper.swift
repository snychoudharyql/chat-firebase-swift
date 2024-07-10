//
//  EnumHelper.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 29/09/23.
//

import Foundation
import UIKit

enum MessageType {
    case initiated
    case partial
}

enum ConstantSize {
    static var twenty = 20.0
    static var ten = 10.0
    static var fifteen = 15.0
    static var thirtyFive = 35.0
    static var twentyFour = 24.0
    static var twentySix = 26.0
    static var fifty = 50.0
    static var twentyTwo = 22.0
    static var forty = 40.0
    static var chatboxWidth = 280.0
    static var sixty = 60.0
    static var thirty = 30.0
}

enum EditBoxSelectionType {
    case send
    case addMedia([UIImage])
}

enum PhotoSourceType {
    case camera
    case gallery
}

enum ImagePickerSelectType {
    case single
    case multiple
    case none
}
