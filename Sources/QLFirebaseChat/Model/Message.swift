//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 15/09/23.
//

import Foundation

public struct Message {
    public let text: String
    public let senderId: String
    public let timestamp: TimeInterval
    
    public init?(data: [String: Any]) {
        guard let text = data["text"] as? String,
              let senderId = data["senderId"] as? String,
              let timestamp = data["timestamp"] as? TimeInterval else {
            return nil
        }
        self.text = text
        self.senderId = senderId
        self.timestamp = timestamp
    }
}

