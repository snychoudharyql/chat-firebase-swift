//
//  CustomTextFieldStyle.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 5))
    }
}
