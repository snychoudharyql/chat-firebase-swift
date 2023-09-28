//
//  MessageMemberView.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

public struct MessageMemberView: View {
    // MARK: - Properties

    public var chat: ChatUser
    public var profileImagePlaceholder = kProfile
    public var dateFormat = "MM/dd/yy hh:mm:a"

    // MARK: - Body

    public var body: some View {
        HStack(spacing: Size.twenty) {
            profileImage
            userDetails
        }
        .padding(.vertical, Size.ten)
        .padding(.horizontal, Size.ten)
    }

    /// Profile Image :  sender profile image
    private var profileImage: some View {
        AsyncImage(url: URL(string: chat.profile ?? "")) { phase in
            switch phase {
            case .empty, .failure:
                Image(profileImagePlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
            @unknown default:
                Image(profileImagePlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: Size.fifty, height: Size.fifty)
        .cornerRadius(Size.fifty / 2)
    }

    /// User Detail :  Add sender detail (including name, last message and time )
    private var userDetails: some View {
        VStack(alignment: .leading) {
            Text(chat.receiverName ?? "")
                .font(.system(size: Size.twentyTwo))
                .fontWeight(.medium)
            Text(chat.lastMessage ?? "")
                .font(.caption)
                .foregroundColor(.gray)
            if let timestamp = chat.messageTimeStamp {
                HStack {
                    Spacer()
                    Text(timestamp.formattedDateWithAMPM(with: dateFormat))
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
