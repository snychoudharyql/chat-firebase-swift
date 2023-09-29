//
//  AsyncImageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 27/09/23.
//

import SwiftUI

struct AsyncImageView: View {
    // MARK: - Properties

    var imageURL = ""
    var placeholderImage = ""

    // MARK: - Body

    var body: some View {
        if let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty, .failure:
                    Image(placeholderImage)
                        .resizable()
                case let .success(image):
                    image
                        .resizable()

                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
