//
//  ContentView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 15/09/23.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    
    @StateObject var user = UserViewModel()
    @State var isLogin = true

    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundGradient
            content
            loadingIndicator
            errorToast
            navigateToDashboard
        }
    }

    // MARK: - Background Gradient
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    private var content: some View {
        VStack {
            Spacer()
            Text("Chat App")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 30))
            VStack {
                inputFields.padding(.top, 10)
                bottomFooter(isLogin: isLogin)
                    .padding(.vertical, 20)
            }.background (
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(36, corners: [.allCorners])
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
            )
            
            Spacer()
        }
        .padding()
    }

    private var inputFields: some View {
        VStack {
            if !isLogin {
                InputTextFieldView(placeholder: "Name", text: $user.userName)
            }
            InputTextFieldView(placeholder: "Email", text: $user.userEmailID)
            InputTextFieldView(placeholder: "Password", text: $user.userPassword)
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(36, corners: [.bottomLeft, .topRight])
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
        )
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var loadingIndicator: some View {
        if user.isLoading {
            VStack {
                Spacer()
                ActivityIndicator()
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var errorToast: some View {
        ToastView(isPresented: $user.errorMessage.isError, message: user.errorMessage.message)
            .zIndex(1)
    }

    private var navigateToDashboard: some View {
        NavigationLink("", destination: DashboardView(), isActive: $user.isUserSuccessfulLogin)
    }
    
    private func bottomFooter(isLogin: Bool) -> some View {
        VStack {
            Button(action: {
                if isLogin {
                    user.loginUser(email: user.userEmailID, password: user.userPassword)
                } else {
                    user.registerUser(email: user.userEmailID, password: user.userPassword)
                }
            }) {
                Text(buttonTitle(isLogin))
                    .foregroundColor(.indigo)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            .shadow(radius: 4, x: 0, y: 3)
            
            HStack {
                Text(bottomTitle(isLogin))
                    .foregroundColor(.gray)
                    .opacity(0.8)
                    .fontWeight(.regular)
                    .font(.system(size: 15))
                
                Text(buttonTitle(!isLogin))
                    .foregroundColor(.blue)
                    .opacity(0.8)
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .onTapGesture {
                        self.isLogin.toggle()
                    }
            }
            .padding(.top, 5)
        }
    }
}
