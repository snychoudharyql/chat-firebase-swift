//
//  ChatMessageView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct ChatMessageView: View {
    @StateObject var userVM = UserViewModel()
    @Environment(\.dismiss) private var dismiss
    var documentID = ""
    var headerTitle = ""
    var body: some View {
        GeometryReader(content: { geometry in
            
            VStack{
                VStack(alignment: .leading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back").resizable()
                            .frame(width: 25, height: 25)
                    }.padding(.leading, 20)
                    HStack(alignment: .center) {
                        Image("profile").resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(40)
                            .padding(.leading, 20)
                        
                        Text(headerTitle)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Spacer()
                        
                    }
                    .frame(width: geometry.size.width, height: 80)
                } .background(content: {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.6)]),
                               startPoint: .leading,
                               endPoint: .trailing
                           )
                    .edgesIgnoringSafeArea(.all)
                })
         
                .padding(.bottom, 20)
                ScrollViewReader { scrollView in
                    List(userVM.messageList, id: \.id) { message in
                        MessageView(message: message)
                            .listRowSeparator(.hidden)
                    }.listStyle(.plain)
                    //onChange(of: userVM.messageList.count, perform: {_ in
                       // scrollView.scrollTo(userVM.messageList.last?.id)
                    //})
                   // scrollView.scrollTo(userVM.messageList.last?.id)
                }
                    
                MessageInputField(messagesManager: userVM, documentID: documentID)
            }
            
            
        })
        .navigationBarBackButtonHidden(true)
        .onAppear {
            userVM.messageList(documentID: documentID)
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView()
    }
}
