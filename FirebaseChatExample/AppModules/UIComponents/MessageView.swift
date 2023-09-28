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
        VStack(alignment: message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing) {
            if let images = message.images, !images.isEmpty {
   
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(images, id: \.self) { imageURL in
                            AsyncImageView(imageURL: imageURL, placeholderImage: kImagePlaceHolder)
                                .cornerRadius(10)
                                .frame(width: 100, height: 100)
                        }
                    }
                }.frame(width: 100, height : CGFloat(images.count) * 110)
            }
            
            if let text = message.text, !text.isEmpty {
                Text(text)
                    .padding()
                    .background(message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing)
        .padding(message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing)
        .padding(.horizontal, 10)
        .onTapGesture {
            showTime.toggle()
        }
    }
}
