//
//  CustomTextField.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: - Properties
    var placeholder: Text
    @Binding var text: String
    
    // MARK: - body
    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            ExpandableTextView(text: $text)
                .frame(minHeight: 40, maxHeight: 40)
                //.background(.red)
            
        }.padding()
    }
}

