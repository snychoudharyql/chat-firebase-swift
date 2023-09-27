//
//  TextView+Extension.swift
//
//
//  Created by Abhishek Pandey on 27/09/23.
//

import Foundation
import UIKit

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }

        return numberOfLines
    }
}
