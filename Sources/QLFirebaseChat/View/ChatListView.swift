//
//  ChatListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

public struct ChatListView: View {
    // MARK: - Properties

    public var delegate: ChatListDelegate?
    @StateObject public var userVM = ChatViewModel()

    // MARK: - Public initializer

    public init(delegate: ChatListDelegate? = nil) {
        self.delegate = delegate
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader(content: { _ in
            VStack {
                ZStack {
                    Color.yellow.edgesIgnoringSafeArea(.all)
                    HStack(alignment: .center) {
                        Color.green
                        Text(ChatList.heading)
                            .font(.system(size: Size.thirtyFive))
                            .fontWeight(.bold)
                        Spacer()
                        Image(ChatList.addMemberImageName).resizable()
                            .frame(width: Size.twentyFour, height: Size.twentyFour)
                            .padding(.trailing, Size.twenty)
                            .onTapGesture {
                                delegate?.didTapButton()
                            }
                    }
                }.frame(height: Size.hundred)

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
