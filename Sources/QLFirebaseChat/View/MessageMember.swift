//
//  MessageMember.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct MessageMember: View {
    // MA
    var chat = ChatUser()
    var body: some View {
        HStack(spacing: Size.twenty) {
            Image(kProfile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Size.fifty, height: Size.fifty)
                .cornerRadius(Size.fifty)

            VStack(alignment: .leading) {
                Text(chat.receiverName ?? "")
                    .font(.system(size: Size.twentyTwo))
                    .fontWeight(.medium)

                Text(chat.lastMessage ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}
