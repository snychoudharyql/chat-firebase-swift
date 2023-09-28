//
//  Message.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//struct Message: Identifiable, Codable {
//    var id: String
//    var text: String
//    var received: Bool
//    var timestamp: Date
//    
//    func toDictionary() -> [String: Any] {
//        return [
//            "id": id,
//            "text": text,
//            "received": received,
//            "timestamp": timestamp
//        ]
//    }
//}

struct ErrorMesaage {
    var message = ""
    var isError = false
}

class MessageModel: Codable, ObservableObject, Identifiable {
    @DocumentID var id: String?
    var senderTime: Timestamp?
    var text: String?
    var senderID: String?
    var images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case images = "urls"
        case senderID = "sender_id"
        case senderTime  = "send_time"
        case text
        case id
    }
}


