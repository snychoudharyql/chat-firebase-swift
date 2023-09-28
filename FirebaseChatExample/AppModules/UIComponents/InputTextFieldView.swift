//
//  InputTextFieldView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 25/09/23.
//

import SwiftUI

struct InputTextFieldView: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .frame(height: 40)
            .padding()
            .textFieldStyle(CustomTextFieldStyle())
    }
}
