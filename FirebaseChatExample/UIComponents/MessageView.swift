//
//  Message.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat

struct MessageView: View {
    var message: MessageModel
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.sender_id != FirebaseManager.shared.getCurrentUser() ? .leading : .trailing) {
            HStack {
                Text(message.text ?? "")
                    .padding()
                    .background(message.sender_id != FirebaseManager.shared.getCurrentUser() ? Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.sender_id != FirebaseManager.shared.getCurrentUser() ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\((message.sender_time!))")//.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.sender_id != FirebaseManager.shared.getCurrentUser() ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.sender_id != FirebaseManager.shared.getCurrentUser() ? .leading : .trailing)
        .padding(message.sender_id != FirebaseManager.shared.getCurrentUser() ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

//struct Message_Previews: PreviewProvider {
//    static var previews: some View {
//       // MessageView(message: Message(id: "12345", text: "I've been coding applications from scratch in SwiftUI and it's so much fun!", received: true, timestamp: Date()))
//    }
//}
