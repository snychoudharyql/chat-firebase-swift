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
    @State var isActionSheetPresented = false
    @State var isCameraOpen = false
    @State private var selectedImage = [UIImage]()
    @State private var isGallerySelected: Bool = false

    // MARK: Initialization

    public init(chatEditVM: ChatEditVM, text: Binding<String>, callback: ((EditBoxSelectionType) -> Void)?) {
        self.chatEditVM = chatEditVM
        _text = text
        self.callback = callback
    }

    // MARK: Body

    public var body: some View {
        HStack {
            addMediaButton
            editTextView
            sendButton
        }
        .actionSheet(isPresented: $isActionSheetPresented, content: actionSheetContent)
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width)
        .sheet(isPresented: $isCameraOpen) {
            ImagePicker(images: $selectedImage, sourceType: .camera) { _ in
            }
        }
        .sheet(isPresented: $isGallerySelected) {
            ImagePicker(images: $selectedImage, sourceType: .photoLibrary) { images in
                callback?(.addMedia(images))
            }
        }
    }

    private var editTextView: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(chatEditVM.emptyFieldPlaceholder)
                    .font(chatEditVM.editFieldFont)
                    .foregroundColor(chatEditVM.editFieldForegroundColor)
                    .padding(.leading, 8)
            }
            ExpandableTextView(
                text: $text,
                foregroundColor: chatEditVM.editFieldForegroundColor,
                backgroundColor: chatEditVM.editFieldBackgroundColor,
                lineNumberCallback: { line in
                    textLine = line
                }
            )
            .font(chatEditVM.editFieldFont)
            .frame(width: 280, height: CGFloat(textLine * 40))
            .padding(.leading, 6)
            .background(chatEditVM.editFieldBackgroundColor)
            .cornerRadius(Size.twenty)
        }
    }

    // Send Button
    private var sendButton: some View {
        Button(action: sendMessage) {
            chatEditVM.sendButtonImage
                .resizable()
                .frame(width: Size.twenty, height: Size.twenty)
                .padding(Size.ten)
                .cornerRadius(Size.twenty)
        }
    }

    // Add Media Button
    private var addMediaButton: some View {
        Button(action: getMediaContent) {
            chatEditVM.addMediaButtonImage
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
        }
    }

    // Send Message
    private func sendMessage() {
        callback?(.send)
    }

    // MARK: Open Action Sheet

    private func getMediaContent() {
        isActionSheetPresented = true
    }

    // MARK: Action Sheet Configuration

    private func actionSheetContent() -> ActionSheet {
        ActionSheet(
            title: Text("Select a Photo"),
            buttons: [
                .default(
                    Text("Take Photo"),
                    action: { onOptionSelected(.camera) }
                ),
                .default(
                    Text("Choose from Library"),
                    action: { onOptionSelected(.gallery) }
                ),
                .cancel {
                    isActionSheetPresented = false
                },
            ]
        )
    }

    // MARK: onOptionSelected

    private func onOptionSelected(_ option: PhotoSourceType) {
        isCameraOpen = option == .camera
        isGallerySelected = option == .gallery
        isActionSheetPresented = false
    }
}
