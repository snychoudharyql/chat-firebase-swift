//
//  ActionSheetView.swift
//
//
//  Created by Abhishek Pandey on 28/09/23.
//

import SwiftUI

struct ActionSheetView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    let action: (Int?) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0 ..< mediaTitles.count, id: \.self) { row in
                    Button(action: {
                        action(row)
                    }) {
                        HStack {
                            Image(systemName: mediaImages[row])
                            Text(mediaTitles[row]).foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                    }
                }
            }.frame(width: UIScreen.main.bounds.width - 20)
                .background(Color.white)
                .cornerRadius(8)

            Button(action: {
                action(nil)
            }) {
                Text(kCancel).foregroundColor(.black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20).background(Color.white)
                    .cornerRadius(8)
            }

        }.frame(width: UIScreen.main.bounds.width).padding(.bottom, 5)
    }
}

struct ActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetView { _ in
        }
    }
}
