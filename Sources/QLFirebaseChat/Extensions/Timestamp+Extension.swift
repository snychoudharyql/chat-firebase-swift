//
//  Timestamp+Extension.swift
//
//
//  Created by Abhishek Pandey on 25/09/23.
//

import Firebase
import Foundation

extension Timestamp {
    func formattedDateWithAMPM(with dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: dateValue())
    }
}
