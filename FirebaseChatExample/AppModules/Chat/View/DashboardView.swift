//
//  ChatListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI
import QLFirebaseChat


struct DashboardView: View {
    // MARK: - Properties
    
    enum SelectionType {
        case cell(QLFirebaseChat.ChatUser)
        case group
        case none
        
        var isNone: Bool {
            if case .none = self {
                return true
            } else {
                return false
            }
        }
    }
    
    @StateObject var chatViewModel = ChatViewModel(title: "Message", headerBackgroundColor: .blue, iconName: kAddGroup, headerForegroundColor: .white, headerTitleFont: .system(size: 30))
    @State private var selectionType: SelectionType = .none
    
    // MARK: - Body
    
    var body: some View {
        ChatListView(delegate: self, chatViewModel: chatViewModel, headerHeight: 60)
        NavigationLink(
            "",
            destination: destinationView,
            isActive: Binding(
                get: { (!self.selectionType.isNone) },
                set: { isActive in
                    if !isActive {
                        resetProperties()
                    }
                }
            ).animation(nil)
        ).hidden()
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch selectionType {
        case .cell(let chatUser):
            ChatMessageView(
                chatID: chatUser.id ?? "",
                memberName: chatUser.receiverName ?? ""
            )
            .onDisappear {
                resetProperties()
            }
        case .group:
            UserListView()
        case .none:
            EmptyView()
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

// MARK: - ChatListDelegate

extension DashboardView: ChatListDelegate {
    func getChat(chat: QLFirebaseChat.ChatUser) {
        selectionType = .cell(chat)
    }
    
    func didTapButton() {
        selectionType = .group
    }
    
    func resetProperties() {
        selectionType = .none
    }
}
