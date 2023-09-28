//
//  ToastView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct ToastView: View {
    @Binding var isPresented: Bool
    var message: String
    
    var body: some View {
        ZStack {
            Color.clear
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .top))
            }
            .padding()
            .animation(.easeInOut)
        }
        .opacity(isPresented ? 1 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(isPresented: .constant(true), message: "")
    }
}
