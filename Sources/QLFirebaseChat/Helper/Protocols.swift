//
//  Protocols.swift
//
//
//  Created by Abhishek Pandey on 22/09/23.
//

import Foundation

public protocol ChatListDelegate {
    func didTapButton()
    func getChat(chat: ChatUser)
}
