//
//  QLImagePicker.swift
//  QLFirebaseChat
//
//  Created by Abhishek Pandey on 13/09/23.
//

import SwiftUI
import UIKit

struct QLImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType

    // Closure callback for multiple images
    var onImagePicked: (([UIImage]) -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<QLImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<QLImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: QLImagePicker

        init(_ parent: QLImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.images = []
            if let uiImage = info[.originalImage] as? UIImage {
                parent.images.append(uiImage)
                // Check if the callback is provided and pass the images
                parent.onImagePicked?(parent.images)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
