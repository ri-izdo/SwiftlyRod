//
//  Color+Extensions.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/20/25.
//

import SwiftUI

extension Color {
    static let topColor = Color(red: 252/255, green: 76/255, blue: 2/255)
    static let centerColor = Color(red: 64/255, green: 49/255, blue: 140/255)
    static let bottomColor = Color(red: 0/255, green: 0/255, blue: 0/255)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
