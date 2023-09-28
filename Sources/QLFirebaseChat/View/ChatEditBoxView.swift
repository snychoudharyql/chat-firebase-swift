//
//  ChatEditBoxView.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 18/09/23.
//

import SwiftUI

public struct ChatEditBoxView: View {
    // MARK: - Properties

    @StateObject var chatEditVM: ChatEditBoxVM
    @Binding var text: String
    @State var textViewHeight = Size.defaultTextViewHeight
    var callback: ((EditBoxSelectionType) -> Void)?
    @State var isActionSheetPresented = false
    @State var isCameraPresented = false
    @State private var selectedImage = [UIImage]()
    @State private var isGalleryPresented: Bool = false
    @State public var pickerSelectionType: ImagePickerSelectType = .multiple

    // MARK: Initialization

    public init(chatEditVM: ChatEditBoxVM, text: Binding<String>, imageSelectionType: ImagePickerSelectType, callback: ((EditBoxSelectionType) -> Void)?) {
        _chatEditVM = StateObject(wrappedValue: chatEditVM)
        _text = text
        pickerSelectionType = imageSelectionType
        self.callback = callback
    }

    // MARK: Body

    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                if chatEditVM.isNeedMediaShare {
                    addMediaButton
                }
                editTextView
                sendButton
            }

            /// isActionSheetPresented:  is used for to present action sheet
            if isActionSheetPresented {
                ActionSheetView { result in
                    if let result {
                        if result == 0 {
                            // open camera
                            actionSheetSelected(with: .camera)
                        } else if result == 1 {
                            // open photo library
                            actionSheetSelected(with: .gallery)
                        }
                    }
                    withAnimation {
                        isActionSheetPresented = false
                    }
                }.background(.black.opacity(0.2))
                    .transition(.opacity)
            }
        }

        /// isCameraOpen : is used to get teh images from the camera
        .sheet(isPresented: $isCameraPresented) {
            CFImagePicker(images: $selectedImage, sourceType: .camera) { images in
                callback?(.addMedia(images))
                selectedImage = []
            }
        }

        /// isGallerySelected:  is used to get the media from the gallery
        .sheet(isPresented: $isGalleryPresented) {
            if pickerSelectionType == .single {
                CFImagePicker(images: $selectedImage, sourceType: .photoLibrary) { images in
                    callback?(.addMedia(images))
                    selectedImage = []
                }
            } else if pickerSelectionType == .multiple {
                CFPhotoPicker(selectedImages: $selectedImage, isPresented: $isGalleryPresented) { images in
                    callback?(.addMedia(images))
                    selectedImage = []
                }
            }
        }
    }

    // MARK: Edit Text View

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
                textViewHeightCallback: { height in
                    textViewHeight = height
                }
            )
            .font(chatEditVM.editFieldFont)
            .frame(width: Size.chatboxWidth, height: Double(textViewHeight))
            .cornerRadius(Size.twenty)
        }
    }

    // MARK: Send Button

    private var sendButton: some View {
        Button(action: sendMessage) {
            chatEditVM.sendButtonImage
                .resizable()
                .frame(width: Size.twenty, height: Size.twenty)
                .padding(Size.ten)
                .cornerRadius(Size.twenty)
        }
    }

    // MARK: AddMediaButton

    private var addMediaButton: some View {
        Button(action: getMediaContent) {
            chatEditVM.addMediaButtonImage
                .resizable()
                .frame(width: Size.twenty, height: Size.twenty)
                .padding(Size.ten)
        }
    }

    // MARK: Send Message

    private func sendMessage() {
        callback?(.send)
        textViewHeight = Size.defaultTextViewHeight
    }

    // MARK: Open Action Sheet

    private func getMediaContent() {
        withAnimation {
            isActionSheetPresented = true
        }
    }

    // MARK: Action Sheet Callback

    private func actionSheetSelected(with option: PhotoSourceType) {
        isCameraPresented = option == .camera
        isGalleryPresented = option == .gallery
        withAnimation {
            isActionSheetPresented = false
        }
    }
}

struct ChatEditBoxView_Previews: PreviewProvider {
    static var previews: some View {
        ChatEditBoxView(chatEditVM: ChatEditBoxVM(isNeedMediaShare: true, sendButtonImage: Image(systemName: "paperplane.fill"), addMediaButtonImage: Image("add_icon"), emptyFieldPlaceholder: "Enter the message", editFieldBackgroundColor: Color.red.opacity(0.3), editFieldForegroundColor: .black, editFieldFont: Font.system(size: 15)), text: .constant("Hi"), imageSelectionType: .single) { type in
            switch type {
            case .addMedia:
                break
            case .send:
                break
            }
        }
    }
}
