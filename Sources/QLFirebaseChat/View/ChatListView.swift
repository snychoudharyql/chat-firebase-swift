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
    @ObservedObject public var chatVM: ChatViewModel

    // MARK: - Public initializer

    public init(delegate: ChatListDelegate? = nil, chatViewModel: ChatViewModel) {
        self.delegate = delegate
        chatVM = chatViewModel
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader(content: { _ in
            VStack {
                ZStack {
                    chatVM.headerBackgroundColor.edgesIgnoringSafeArea(.all)
                    HStack(alignment: .center) {
                        Text(chatVM.headerTitle)
                            .foregroundColor(chatVM.headerForegroundColor)
                            .font(chatVM.headerTitleFont)
                            .fontWeight(.bold)
                        Spacer()
                        Image(chatVM.addGroupIcon).resizable()
                            .frame(width: Size.twentyFour, height: Size.twentyFour)
                            .padding(.trailing, Size.twenty)
                            .onTapGesture {
                                delegate?.didTapButton()
                            }
                    }.padding(.horizontal, Size.ten)
                }.frame(height: Size.hundred)

                // MARK: Chat List

                List(chatVM.chatList, id: \.id) { chat in
                    MessageMemberView(chat: chat)
                        .onTapGesture {
                            delegate?.getMemberChat(chat: chat)
                        }
                }
                .listStyle(.plain)
            }
        })
        .onAppear {
            chatVM.getChatList()
        }
        .navigationBarBackButtonHidden(true)
    }
}
