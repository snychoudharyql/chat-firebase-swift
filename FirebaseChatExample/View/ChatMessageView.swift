//
//  ChatMessageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

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
        GeometryReader { geometry in
                VStack {
                    navigationHeader
                    headerContent(geometry: geometry)
                    messageList
                    MessageInputField(messagesManager: userVM, documentID: chatID, receiverID: memberID).padding(.horizontal, 20)
                }
            
            }
        .onAppear(perform: {
            userVM.messageList(documentID: chatID)
        })
        .navigationBarBackButtonHidden(true)
    }
    
    /// Navigation header configuration
    private var navigationHeader: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Image(kBackButton)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            .padding(.leading, 20)
            
            HStack(alignment: .center) {
                Image(kProfile)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(40)
                    .padding(.leading, 20)
                
                Text(memberName)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: 80)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.6)]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .padding(.bottom, 20)
    }
    
    private func headerContent(geometry: GeometryProxy) -> some View {
        EmptyView()
    }
    
    /// Message list display
    private var messageList: some View {
        ScrollViewReader { scrollView in
            List(userVM.messageList, id: \.id) { message in
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



