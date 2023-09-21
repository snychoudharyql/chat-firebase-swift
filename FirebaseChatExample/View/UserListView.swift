//
//  UserListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct UserListView: View {
    @StateObject var userVM  = UserViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var isOpenChatMessage = false
    @State var individualUser = ChatListUser()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(kBackButton).resizable()
                        .frame(width: 26, height: 24)
                }
                
                Text("User List")
                    .font(.title)
            }.padding(.top, 24)
            List(userVM.users, id: \.id) { item in
                userDetail(chatUser: item)
                    .onTapGesture {
                        userVM.isMemberChatInitiated(with: item.uid ?? "") { users in
                            if (users ?? []).isEmpty {
                                userVM.chatInitate(groupName: "", uID: item.uid ?? "")
                            } else {
                                individualUser = (users?.last)!
                                individualUser.id = (users?.last)!.id
                                isOpenChatMessage = true
                            }
                        }
                      //
                    }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
        }.padding(.horizontal, 20)
        .onAppear {
            userVM.getUserList()
        }
        .navigationBarBackButtonHidden(true)
        NavigationLink("", destination: ChatMessageView(documentID: individualUser.id ?? "2D19A92C-7AFF-438F-99DA-8DBE49C62137", headerTitle: individualUser.receiverName ?? ""), isActive: $isOpenChatMessage)
        
    }
    
    @ViewBuilder
    func userDetail(chatUser: User) -> some View {
            HStack {
                Image("profile").resizable()
                    .frame(width: 30, height: 30).cornerRadius(30)
                Text(chatUser.name ?? "Abhi")
                    .fontWeight(.medium)
                Spacer()
            }.padding(.vertical, 10).padding(.leading, 10).background {
                Color.gray.opacity(0.15)
            }.frame(width: 360)
             .cornerRadius(10)
          
    }
    
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

