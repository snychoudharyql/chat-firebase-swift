//
//  ExpandableTextView.swift
//
//  Created by Abhishek Pandey on 26/09/23.
//

import SwiftUI
import UIKit

struct ExpandableTextView: UIViewRepresentable {
    @Binding var text: String
    var foregroundColor = Color.black
    var backgroundColor = Color.clear
    var lineNumberCallback: ((Int) -> Void)?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = UIColor(backgroundColor)
        textView.textColor = UIColor(foregroundColor)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        // textView.textContainer.maximumNumberOfLines = 10
        // textView.textContainer.lineBreakMode = .byTruncatingTail
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
        var parent: ExpandableTextView

        init(_ parent: ExpandableTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            expandTextView(textView)
        }

        private func expandTextView(_ textView: UITextView) {
            let maxLines = 5

            let numberOfLines = textView.contentSize.height / textView.font!.lineHeight

            if Int(numberOfLines) >= maxLines {
                textView.isScrollEnabled = true
            } else {
                textView.isScrollEnabled = false
                // textView.contentOffset = .zero
            }

            let textArray = textView.text.components(separatedBy: "\n")
            if numberOfLines <= 5 {
                if let lineNumberCallback = parent.lineNumberCallback {
                    lineNumberCallback(Int(textArray.isEmpty ? 1 : textArray.count))
                }
            }
        }
    }
}
