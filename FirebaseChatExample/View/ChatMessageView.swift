//
//  ChatMessageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct ChatMessageView: View {
    @StateObject var userVM = ChatViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var documentID = ""
    var memberName = ""
    var messageType = MessageType.initiated
    var memberID = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                navigationHeader
                headerContent(geometry: geometry)
                messageList
                MessageInputField(messagesManager: userVM, documentID: $documentID, receiverID: memberID)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                userVM.messageList(documentID: documentID)
            }
        }
    }
    
    private var navigationHeader: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Image("back")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            .padding(.leading, 20)
            
            HStack(alignment: .center) {
                Image("profile")
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
    
    private var messageList: some View {
        ScrollViewReader { scrollView in
            List(userVM.messageList, id: \.id) { message in
                MessageView(message: message)
                    .listRowSeparator(.hidden)
                    .id(message.id)
            }
            .listStyle(.plain)
//            .onChange(of: userVM.messageList.count) { newValue in
//               // if newValue > userVM.messageList.count {
//                    if let id = userVM.messageList.last?.id {
//                        scrollView.scrollTo(id)
//                    }
//                //}
//            }
            .onAppear {
                scrollView.scrollTo(userVM.messageList.last?.id)
            }
        }
    }
    

}


struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView()
    }
}
