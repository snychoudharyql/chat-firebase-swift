//
//  MessageMember.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct MessageMember: View {
    var imageUrl = URL(string: "")
    var name = "Abhishek"
   // @StateObject var message: UserViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 22))
                    .fontWeight(.medium)
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

struct MessageMember_Previews: PreviewProvider {
    static var previews: some View {
        MessageMember()
    }
}
