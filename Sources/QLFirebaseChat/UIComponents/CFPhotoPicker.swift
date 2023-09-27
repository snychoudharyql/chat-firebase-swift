//
//  CFPhotoPicker.swift
//  FirebaseChatExample
//
//  Created by Abhishek Pandey on 26/09/23.
//

import PhotosUI
import SwiftUI

struct CFPhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var isPresented: Bool
    var onImagePicked: (([UIImage]) -> Void)?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: PHPickerViewController, context _: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: CFPhotoPicker

        init(_ parent: CFPhotoPicker) {
            self.parent = parent
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages = []
            let group = DispatchGroup()
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error {
                        print("Error loading image: \(error.localizedDescription)")
                    } else if let image = image as? UIImage {
                        self.parent.selectedImages.append(image)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.parent.onImagePicked?(self.parent.selectedImages)
                self.parent.isPresented = false
            }
        }
    }
}
