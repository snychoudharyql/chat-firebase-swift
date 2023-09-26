//
//  ChatEditVM.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 26/09/23.
//

import Foundation
import SwiftUI

public class ChatEditVM: ObservableObject {
    @Published var isNeedMediaShare = false

    // UI Component configuration
    let sendButtonImage: Image
    let addMediaButtonImage: Image
    let emptyFieldPlaceholder: String
    let editFieldBackgroundColor: Color
    let editFieldForegroundColor: Color
    let editFieldFont: Font

    public init(isNeedMediaShare: Bool = false, sendButtonImage: Image, addMediaButtonImage: Image, emptyFieldPlaceholder: String, editFieldBackgroundColor: Color, editFieldForegroundColor: Color, editFieldFont: Font) {
        self.isNeedMediaShare = isNeedMediaShare
        self.sendButtonImage = sendButtonImage
        self.addMediaButtonImage = addMediaButtonImage
        self.emptyFieldPlaceholder = emptyFieldPlaceholder
        self.editFieldBackgroundColor = editFieldBackgroundColor
        self.editFieldForegroundColor = editFieldForegroundColor
        self.editFieldFont = editFieldFont
    }
}
