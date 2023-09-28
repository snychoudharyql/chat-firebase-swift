//
//  View+Extension.swift
//  FireStoreProject
//
//  Created by Abhishek Pandey on 13/09/23.
//

import SwiftUI
import UIKit


extension View {
    // custom border color with different corner
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    // custom corner Radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
}
