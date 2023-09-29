//
//  UserChatListView.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

public struct UserChatListView: View {
    // MARK: - Properties

    public var delegate: ChatListDelegate?
    @ObservedObject public var chatVM: ChatViewModel
    public var headerHeight: CGFloat

    // MARK: - Public initializer

    public init(delegate: ChatListDelegate? = nil, chatViewModel: ChatViewModel, headerHeight: CGFloat) {
        self.delegate = delegate
        chatVM = chatViewModel
        self.headerHeight = headerHeight
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader(content: { _ in
            VStack {
                ZStack {
                    chatVM.navigationBarBackgroundColor.edgesIgnoringSafeArea(.all)
                    HStack(alignment: .center) {
                        Text(chatVM.navigationBarTitle)
                            .foregroundColor(chatVM.navigationBarTitleForegroundColor)
                            .font(chatVM.navigationBarTitleFont)
                            .fontWeight(.bold)
                        Spacer()
                        Image(chatVM.navigationBarRightButtonImage).resizable()
                            .frame(width: Size.twentyFour, height: Size.twentyFour)
                            .padding(.trailing, Size.twenty)
                            .onTapGesture {
                                delegate?.didTapButton()
                            }
                    }.padding(.horizontal, Size.ten)
                }.frame(height: headerHeight)

                // MARK: Chat List

                List(chatVM.userChatList, id: \.id) { chat in
                    InboxMessageView(chat: chat)
                        .onTapGesture {
                            delegate?.getChat(chat: chat)
                        }
                }
                .listStyle(.plain)
            }
        })
        .onAppear {
            chatVM.getUserChatList()
        }
        .navigationBarBackButtonHidden(true)
    }
}
