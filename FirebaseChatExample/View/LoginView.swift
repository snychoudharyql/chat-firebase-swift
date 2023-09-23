//
//  ContentView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: - Properties
    @StateObject var user = UserViewModel()
    @State var islogin = true
    //MARK: - Body
    
    var body: some View {
        GeometryReader(content: { geometry in
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.6)]),
                       startPoint: .top,
                       endPoint: .bottom
                   )
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    Spacer()
                    Text("Chat App").foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    VStack(alignment: .center) {
                        VStack {
                            if !islogin {
                                InputTextFieldView(placeholder: "Name",text: $user.userName)
                            }
                            InputTextFieldView(placeholder: "Email",text: $user.userEmailID)
                            InputTextFieldView(placeholder: "Password",text: $user.userPassword)
                        }.padding().background {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(36, corners: [.bottomLeft, .topRight])
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                            
                        }.padding(.top, 20)
                            .padding(.horizontal, 20)
                        bottomFooter(isLogin: islogin)
                            .padding(.vertical, 20)
                        
                    }.background {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(14) // Optionally round the corners
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                        
                    }
                    .padding()
                    Spacer()
                }
                
                if user.isLoading  {
                    VStack {
                        Spacer()
                        ActivityIndicator()
                        Spacer()
                    }.frame(width: geometry.size.width)
                }
            }
            
            .overlay {
                ToastView(isPresented: $user.errorMessage.isError, message: user.errorMessage.message).zIndex(1)
                
            }
            
            NavigationLink("", destination: DashboardView(), isActive: $user.isUserSuccessfulLogin)
        })
    
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct InputTextFieldView: View {
    var placeholder = ""
    @Binding var text: String
    var body: some View {
        TextField(placeholder,text: $text).frame(height: 40).padding().textFieldStyle(CustomTextFieldStyle())
    }
}


extension LoginView {
    @ViewBuilder
    func bottomFooter(isLogin: Bool) -> some View {
        VStack {
            Button {
                if isLogin {
                    user.loginUser(email: user.userEmailID, password: user.userPassword)
                } else {
                    user.registerUser(email: user.userEmailID, password: user.userPassword)
                }
                
            } label: {
                Text( isLogin ? "Login" : "SignUp")
                    .foregroundColor(.indigo)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
            }.padding(.vertical, 10).padding(.horizontal, 20).background(.gray.opacity(0.05))
                .cornerRadius(10).shadow(radius: 4, x: 0, y:3)
            HStack {
                Text(isLogin ? "Create new account" : "Already have account?")
                    .foregroundColor(.gray).opacity(0.8)
                    .fontWeight(.regular)
                    .font(.system(size: 15))
                
                Text(isLogin ? "SignUp" : "Login")
                    .foregroundColor(.blue).opacity(0.8)
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .onTapGesture {
                        self.islogin = !isLogin
                    }
                
            }.padding(.top, 5)
            
        }
    }
}
