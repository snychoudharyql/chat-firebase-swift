//
//  ExpandableTextView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 25/09/23.
//

import UIKit
import SwiftUI


struct ExpandableTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        //textView.textContainer.maximumNumberOfLines = 5
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ExpandableTextView
        
        init(_ parent: ExpandableTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfLines = newText.components(separatedBy: "\n").count
            return numberOfLines <= 5
        }
    }
    
}


