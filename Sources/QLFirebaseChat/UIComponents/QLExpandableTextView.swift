//
//  QLExpandableTextView.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 25/09/23.
//

import SwiftUI
import UIKit

struct QLExpandableTextView: UIViewRepresentable {
    // MARK: - Properties

    @Binding var text: String
    var foregroundColor = Color.black
    var backgroundColor = Color.clear
    var textViewHeightCallback: ((Double) -> Void)?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = UIColor(backgroundColor)
        textView.textColor = UIColor(foregroundColor)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 8)
        textView.textContainer.maximumNumberOfLines = .max
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.autocorrectionType = .no
        textView.delegate = context.coordinator

        return textView
    }

    func updateUIView(_ uiView: UITextView, context _: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: QLExpandableTextView

        init(_ parent: QLExpandableTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            expandTextView(textView: textView)
        }

        func expandTextView(textView: UITextView) {
            let maxLines = 5
            let numLines = textView.numberOfLines()

            textView.isScrollEnabled = true
            if Int(numLines) >= maxLines {
            } else {
                parent.textViewHeightCallback?(textView.contentSize.height)
            }
            parent.text = textView.text
        }
    }
}
