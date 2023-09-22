//
//  Protocols.swift
//
//
//  Created by Abhishek Pandey on 22/09/23.
//

import Foundation

protocol ChatListDelegate {
    func didTapButton()
    func getMemberChat(chat: ChatUser)
}
