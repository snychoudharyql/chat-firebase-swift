//
//  AsyncImageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 27/09/23.
//

import SwiftUI

struct AsyncImageView: View {
    var imageURL = ""
    var placeholderImage = ""
    
    var body: some View {
        if let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty, .failure:
                    Image(placeholderImage)
                        .resizable()
                case .success(let image):
                    image
                        .resizable()
                    
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView()
    }
}
