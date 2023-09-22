//
//  ChatListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

struct ChatListView: View {
    @State var isAddNewGroup = false
    @StateObject var userVM = ChatViewModel()
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                ZStack {
                    HStack {
                        Text("Message")
                            .font(.system(size: 35))
                            .fontWeight(.bold).padding(.top, 10)
                        Spacer()
                        Button {
                            isAddNewGroup = true
                        } label: {
                            Image("add_icon").resizable()
                                .frame(width: 24, height: 24)
                        }.padding(.trailing, 10)
                        
                        Button {
                            
                        } label: {
                            Image("logout").resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                    } .padding(.horizontal, 20).padding(.vertical, 15)
                    
                        .background {
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.6)]),
                                       startPoint: .leading,
                                       endPoint: .trailing
                                   )
                            .edgesIgnoringSafeArea(.all)
                        }
                }
                
                List(userVM.chatList, id: \.id) { item in
                    NavigationLink(destination: ChatMessageView(documentID: item.id ?? "", memberName: item.receiverName ?? "")) {
                        MessageMember(name: item.receiverName ?? "")
                    }
                //.listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                
            }
            .navigationBarBackButtonHidden(true)
            NavigationLink("", destination: UserListView( dismissPresented: $isAddNewGroup), isActive: $isAddNewGroup)
            
        })
        .onAppear {
            userVM.getChatList()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}

