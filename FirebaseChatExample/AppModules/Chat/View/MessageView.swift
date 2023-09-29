//
//  Message.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat
import UIKit

struct MessageView: View {
    
    // MARK: - Properties
    var message: MessageModel
    var showTime = true
    var senderViewBackgroundColor = Color.blue
    var receiverViewBackgroundColor = Color.gray
    var senderTextForegorundColor = Color.white
    var receiverTextForegroundColor = Color.black
    var messageTextFont = (Font.system(size: 16))
    var backgroundViewCornerRadius = 16.0
    
    var body: some View {
        VStack(alignment: messageHorizontalAlignment) {
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
                VStack(alignment: .trailing, spacing: 2) {
                    Text(text)
                        .font(messageTextFont)
                        .foregroundColor(textColor)
                    if showTime, let time = message.senderTime {
                        Text("\(time.formattedDateWithAMPM(with: "dd/MM/yy"))")
                            .foregroundColor(textColor)
                            .font(.system(size: 8))
                            .fontWeight(.regular)
                            
                    }
                }.padding(.all, 12) .background(backgroundColor).cornerRadius(backgroundViewCornerRadius)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing)
        .padding(paddingAlignment)
        .padding(.horizontal, 10)
        
    }
    
    // MARK: -  Components Helpers
    private var textColor: Color {
        return message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? receiverTextForegroundColor : senderTextForegorundColor
    }
    
    private var backgroundColor: Color {
        return message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? receiverViewBackgroundColor : senderViewBackgroundColor
    }
    private var messageHorizontalAlignment: HorizontalAlignment {
        return message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing
    }
    
    private var paddingAlignment: Edge.Set {
           return message.senderID != FirebaseManager.shared.getCurrentUser(with: .UID) ? .leading : .trailing
       }
}

