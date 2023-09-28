//
//  ChatMessageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat

struct ChatMessageView: View {
    // MARK: - Properties
    
    @StateObject var userVM = MessageViewModel()
    @Environment(\.dismiss) private var dismiss
    var chatID = ""
    var memberName = ""
    var messageType = MessageType.initiated
    var memberID = ""
    
    // MARK: - Initialization
    init(chatID: String, memberName: String, memberID: String = "") {
        self.chatID = chatID
        self.memberName = memberName
        self.memberID = memberID
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ChatNavigationHeaderView(title: memberName, backButtonImage: Image(kBackButton), profileImage: kProfile, profilePlaceholderImage: kProfile, headerHeight: 60, titleForegroundColor: .white, backgroundColor: .blue) {
                    dismiss()
                }
                messageList
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            }
            CustomMessageInputView(messagesManager: userVM, documentID: chatID, receiverID: memberID).padding(.horizontal, 20)
        }
        .onAppear(perform: {
            userVM.messageList(documentID: chatID)
        })
        .navigationBarBackButtonHidden(true)
    }
    
    
    private func headerContent(geometry: GeometryProxy) -> some View {
        EmptyView()
    }
    
    /// Message list display
    private var messageList: some View {
        Group {
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(userVM.messageList, id: \.id) { message in
                        MessageView(message: message)
                            .listRowSeparator(.hidden)
                            .id(message.id)
                    }
                    .listStyle(.plain)
                    .onChange(of: userVM.messageList.count) { newValue in
                        withAnimation {
                            scrollView.scrollTo(userVM.messageList.last?.id)
                        }
                    }
                }
                
            }
        }
    }
    

}



