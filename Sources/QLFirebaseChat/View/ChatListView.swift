//
//  ChatListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

struct ChatListView: View {
    // MARK: - Properties

    @StateObject var userVM = ChatViewModel()

    // MARK: - Body

    var body: some View {
        GeometryReader(content: { _ in
            VStack {
                ZStack {
                    ChatList.headerBackgroundColor
                    HStack {
                        Text(ChatList.heading)
                            .font(.system(size: Size.thirtyFive))
                            .fontWeight(.bold).padding(.top, 10)
                        Spacer()
                        NavigationLink {} label: {
                            Image(ChatList.addMemberImageName).resizable()
                                .frame(width: Size.twentyFour, height: Size.twentyFour)
                        }.padding(.trailing, Size.ten)

                    }.padding(.horizontal, Size.fifteen).padding(.vertical, Size.fifteen)
                }

                List(userVM.chatList, id: \.id) { chat in
                    MessageMember(chat: chat)
                }
                .listStyle(.plain)
            }
            .navigationBarBackButtonHidden(true)
        })
        .onAppear {
            userVM.getChatList()
        }
        .navigationBarBackButtonHidden(true)
    }
}
