//
//  ChatMessageNavigationBarView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 28/09/23.
//

import SwiftUI

public struct ChatMessageNavigationBarView: View {
    // MARK: - Properties

    public let title: String
    public let backButtonImage: Image
    public let profileImage: String
    public let profilePlaceholderImage: String
    public let headerHeight: CGFloat
    public let titleForegroundColor: Color
    public let backgroundColor: Color
    public let dismiss: () -> Void

    // MARK: - Public initializer

    public init(title: String, backButtonImage: Image, profileImage: String, profilePlaceholderImage: String, headerHeight: CGFloat, titleForegroundColor: Color, backgroundColor: Color, dismiss: @escaping () -> Void) {
        self.title = title
        self.backButtonImage = backButtonImage
        self.profileImage = profileImage
        self.profilePlaceholderImage = profilePlaceholderImage
        self.headerHeight = headerHeight
        self.titleForegroundColor = titleForegroundColor
        self.backgroundColor = backgroundColor
        self.dismiss = dismiss
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .center) {
            Button {
                dismiss()
            } label: {
                backButtonImage
                    .resizable()
                    .frame(width: Size.twentyFive, height: Size.twentyFive)

            }.padding(.leading, Size.fifteen)
            AsyncImageView(imageURL: profileImage, placeholderImage: profilePlaceholderImage)
                .frame(width: headerHeight - Size.twenty, height: headerHeight - Size.twenty)
                .cornerRadius(headerHeight - Size.twenty)
                .padding(.leading, 5)

            Text(title)
                .foregroundColor(titleForegroundColor)
                .font(.system(size: Size.twenty))
                .fontWeight(.semibold)
                .padding(.leading, 5)

            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: headerHeight)
        .background(backgroundColor)
    }
}
