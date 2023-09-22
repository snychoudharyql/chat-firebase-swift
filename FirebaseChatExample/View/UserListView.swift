//
//  UserListView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI
import QLFirebaseChat

struct UserListView: View {
    // MARK: - Properties
    
    @StateObject var userVM = ChatViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var individualUser = [ChatListUser]()
    @State var selectedUsers: [User] = []
    @State var isMultiSelectionActive = false
    @State private var isAlertPresented = false
    @State private var userInput = ""
    @Binding var dismissPresented: Bool // remove this
    @State var isSelectedUser = false
    @State var singleUser = User()
    
    // MARK:  Body
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                navigationHeader
                
                List(userVM.users, id: \.email) { item in
                    userDetail(chatUser: item, isSelect: selectedUsers.contains(where: { user in
                        user.email == item.email
                    }))
                    .onTapGesture {
                        handleUserTap(item)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .padding(.horizontal, 20)
            
            groupChatButton
            
        }
        .alert("Group", isPresented: $isAlertPresented) {
            TextField("Name", text: $userInput)
            Button("OK", action: createGroupChat)
        }
        .onAppear {
            userVM.getUserList()
        }
        .navigationBarBackButtonHidden(true)
        
        navigationLinkToChat
    }
    
    private var navigationHeader: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(kBackButton)
                    .resizable()
                    .frame(width: 26, height: 24)
            }
            Text("User List")
                .font(.title)
            Spacer()
            toggleMultiSelectionButton
        }
        .padding(.top, 24)
    }
    
    private var toggleMultiSelectionButton: some View {
        Button(action: {
            isMultiSelectionActive.toggle()
            selectedUsers = []
        }) {
            Text(isMultiSelectionActive ? "Remove" : "Create Group Chat")
        }
    }
    
    private var groupChatButton: some View {
        Group {
            if !selectedUsers.isEmpty {
                Button {
                    isAlertPresented = true
                } label: {
                    Image(kAddMember)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .padding(.bottom, 20)
                .padding(.trailing, 20)
            }
        }
    }
    
    private var navigationLinkToChat: some View {
        NavigationLink("", destination: chatDestination, isActive: $isSelectedUser)
    }
    
    private var chatDestination: some View {
        Group {
            if individualUser.isEmpty {
                ChatMessageView(documentID: "", memberName: singleUser.name ?? "",
                                memberID: singleUser.uid ?? "")
            } else if let individualUser = individualUser.first, let id = individualUser.id {
                ChatMessageView(documentID: id,
                                memberName: individualUser.receiverName ?? "")
            } else {
                EmptyView()
            }
        }
    }
    
    private func handleUserTap(_ user: User) {
        if user.isOnContact ?? false  {
            if isMultiSelectionActive {
                toggleSelection(for: user)
            } else {
                initiateChat(with: user)
            }
        }
    }
    
    private func initiateChat(with user: User) {
        singleUser = user
        userVM.isMemberChatInitiated(with: user.uid ?? "") { users in
            individualUser = users ?? []
            isSelectedUser = true
        }
    }
    
    private func createGroupChat() {
        let emailArray = selectedUsers.map { $0.uid ?? "" }
        userVM.chatInitate(groupName: userInput, uIDs: ([FirebaseManager.shared.getCurrentUser(with: .UID)] + emailArray)) { isSuccess in
            dismiss()
        }
    }
    
    private func toggleSelection(for user: User) {
        if let index = selectedUsers.firstIndex(where: { $0.email == user.email }) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(dismissPresented: .constant(false))
    }
}



extension UserListView  {
    
    @ViewBuilder
    func userDetail(chatUser: User, isSelect: Bool) -> some View {
        HStack {
            Image("profile").resizable()
                .frame(width: 30, height: 30).cornerRadius(30)
            Text(chatUser.name ?? "")
                .fontWeight(.medium)
            Spacer()
            if chatUser.isOnContact ?? false  {
                if isMultiSelectionActive {
                    Image(isSelect ? "select" : "unSelect").resizable()
                        .frame(width: 20, height:20)
                        .padding(.trailing, 20)
                }
            } else {
                Button {
                    
                } label: {
                    Text("Invite")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                    
                        .foregroundColor(.white)
                        .background(.green)
                }.padding(.trailing, 10)

            }
            
        }.padding(.vertical, 10).padding(.leading, 10).background {
            Color.gray.opacity(0.15)
        }.frame(width: 360)
            .cornerRadius(10)
        
    }
}
