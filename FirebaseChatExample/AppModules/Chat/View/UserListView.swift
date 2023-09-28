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
    
    @StateObject var userVM = MessageViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var individualUser = [ChatListUser]()
    @State var selectedUsers: [User] = []
    @State var isMultiSelectionActive = false
    @State private var isAlertPresented = false
    @State private var groupName = ""
    @State var isSelectedUser = false
    @State var singleUser = User()
    
    // MARK:  Body
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            VStack(alignment: .leading) {
                
                /// Navigation header view
                navigationHeader
                
                /// Requested user list
                List(userVM.users, id: \.email) { item in
                    ContactUser(chatUser: item, isSelect: selectedUsers.contains(where: { user in
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
            TextField("Name", text: $groupName)
            Button("OK", action: createGroupChat)
        }
        .onAppear {
            userVM.getUserList()
        }
        .navigationBarBackButtonHidden(true)
            navigationLinkToChat
    }
    
    // MARK: - UI Component Helpers
    
    // MARK: Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(kBackButton)
                    .resizable()
                    .frame(width: 26, height: 24)
            }
            Text(kUserTitle)
                .font(.title)
            Spacer()
            toggleMultiSelectionButton
        }
        .padding(.top, 24)
    }
    
    // MARK: Toggle MultiSelection Button
    private var toggleMultiSelectionButton: some View {
        Button(action: {
            isMultiSelectionActive.toggle()
            selectedUsers = []
        }) {
            Text(groupButtonTittle(isMultiSelectionActive))
        }
    }
    
    // MARK: Navigation Link To Chat
    private var navigationLinkToChat: some View {
        NavigationLink(
            "",
            destination: chatDestination,
            isActive: Binding(
                get: { isSelectedUser },
                set: { isActive in
                    if !isActive {
                        resetNavigation()
                    }
                }
            )
        )
        .hidden()
    }
    
    // MARK: ChatDestination
    private var chatDestination: some View {
        Group {
            if individualUser.isEmpty {
                ChatMessageView(chatID: "",
                                memberName: singleUser.name ?? "",
                                memberID: singleUser.uid ?? "")
                
            } else if let individualUser = individualUser.first, let id = individualUser.id {
                ChatMessageView(chatID: id,
                                memberName: individualUser.receiverName ?? "")

            }
        }
        
    }
    
    // MARK: Group Chat Button
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
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}



extension UserListView  {
    @ViewBuilder
    func ContactUser(chatUser: User, isSelect: Bool) -> some View {
        HStack {
            Image(kProfile).resizable()
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
                    /// code :  for to send a invitation
                } label: {
                    Text(kInvite)
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

//MARK: - Action Helpers
extension UserListView {
    
    /// Create group :  chat initiate with multiple users
    private func createGroupChat() {
        let emailArray = selectedUsers.map { $0.uid ?? "" }
        if !groupName.isEmpty {
            userVM.chatInitate(groupName: groupName, uIDs: ([FirebaseManager.shared.getCurrentUser(with: .UID)] + emailArray)) { isSuccess in
                dismiss()
            }
        }
    }
    
    /// Multiple section :  add members in group
    private func toggleSelection(for user: User) {
        if let index = selectedUsers.firstIndex(where: { $0.email == user.email }) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
    }
    
    /// Inititate Chat :  check is user have intitate chat in before
    private func initiateChat(with user: User) {
        singleUser = user
        userVM.isMemberChatInitiated(with: user.uid ?? "") { users in
            individualUser = users ?? []
            isSelectedUser = true
        }
    }
    
    /// User check is this user in contact list have acount in app
    private func handleUserTap(_ user: User) {
        if user.isOnContact ?? false  {
            if isMultiSelectionActive {
                toggleSelection(for: user)
            } else {
                initiateChat(with: user)
            }
        }
    }
    
    private func resetNavigation() {
        isSelectedUser = false
        singleUser = User() // Reset the singleUser state
        individualUser = [] // Reset the individualUser state
    }

}
