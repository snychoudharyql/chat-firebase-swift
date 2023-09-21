//
//  Message.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
   
    func toDictionary() -> [String: Any] {
           return [
               "id": id,
               "text": text,
               "received": received,
               "timestamp": timestamp
           ]
       }
}

struct ErrorMesaage {
    var message = ""
    var isError = false
}

class MessageModel: Codable, ObservableObject, Identifiable {
    @DocumentID var id: String?
    var sender_time: Timestamp?
    var text: String?
    var sender_id: String?
}


