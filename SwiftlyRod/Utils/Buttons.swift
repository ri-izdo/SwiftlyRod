//
//  Buttons.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/13/25.
//

import Foundation
import SwiftUI


struct WorkoutTypeButton: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("SF Pro", size: 14))
            .opacity(isActive ? 1 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .cornerRadius(6)
            .tint(.orange)
    }
}
