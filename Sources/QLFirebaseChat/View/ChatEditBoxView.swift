//
//  ChatEditBoxView.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

public struct ChatEditBoxView: View {
    // MARK: - Properties

    @ObservedObject var chatEditVM: ChatEditVM
    @Binding var text: String
    @State var textLine = 1
    var callback: ((EditBoxSelectionType) -> Void)?

    // MARK: Initialization

    public init(chatEditVM: ChatEditVM, text: Binding<String>, callback: ((EditBoxSelectionType) -> Void)?) {
        self.chatEditVM = chatEditVM
        _text = text
        self.callback = callback
    }

    // MARK: Body

    public var body: some View {
        HStack {
            addMedia
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(chatEditVM.emptyFieldPlaceholder)
                        .font(chatEditVM.editFieldFont)
                        .foregroundColor(chatEditVM.editFieldForegroundColor)
                        .padding(.leading, 7)
                }
                ExpandableTextView(text: $text,
                                   foregroundColor: chatEditVM.editFieldForegroundColor,
                                   backgroundColor: chatEditVM.editFieldBackgroundColor,
                                   lineNumberCallback: { line in
                                       textLine = line
                                   }).font(chatEditVM.editFieldFont)
                    .frame(height: CGFloat(textLine * 40))
                    .padding(.leading, 5)
                    .background(chatEditVM.editFieldBackgroundColor)

                    .cornerRadius(20)
            }
            sendButton
        }
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width)
    }

    private var sendButton: some View {
        Button(action: sendMessage) {
            chatEditVM.sendButtonImage
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
                .cornerRadius(20)
        }
    }

    private var addMedia: some View {
        Button(action: getMediaContent) {
            chatEditVM.addMediaButtonImage
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
        }
    }

    private func sendMessage() {
        callback?(.send)
    }

    private func getMediaContent() {
        callback?(.addMedia)
    }
}
