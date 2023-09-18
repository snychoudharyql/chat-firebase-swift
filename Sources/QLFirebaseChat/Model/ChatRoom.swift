//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 15/09/23.
//

import Foundation

public struct ChatRoom {
    public let name: String
    public let participants: [String]
    
    public init?(data: [String: Any]) {
        guard let name = data["name"] as? String,
              let participants = data["participants"] as? [String] else {
            return nil
        }
        self.name = name
        self.participants = participants
    }
}
