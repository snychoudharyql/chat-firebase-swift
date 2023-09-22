//
//  ChatListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

public struct ChatListView: View {
    // MARK: - Properties

    var delegate: ChatListDelegate?
    @StateObject var userVM = ChatViewModel()

    // MARK: - Body

    public var body: some View {
        GeometryReader(content: { _ in
            VStack {
                ZStack {
                    ChatList.headerBackgroundColor
                    HStack {
                        Text(ChatList.heading)
                            .font(.system(size: Size.thirtyFive))
                            .fontWeight(.bold).padding(.top, 10)
                        Spacer()
                        Image(ChatList.addMemberImageName).resizable()
                            .frame(width: Size.twentyFour, height: Size.twentyFour)
                            .padding(.trailing, Size.ten)
                            .onTapGesture {
                                delegate?.didTapButton()
                            }

                    }.padding(.horizontal, Size.fifteen).padding(.vertical, Size.fifteen)
                }

                List(userVM.chatList, id: \.id) { chat in
                    MessageMember(chat: chat)
                        .onTapGesture {
                            delegate?.getMemberChat(chat: chat)
                        }
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
