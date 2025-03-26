//
//  AnimationModifier.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/25/25.
//

import Foundation
import SwiftUI

struct AnimationModifier : ViewModifier{
    let positionOffset : Double
    let height = UIScreen.main.bounds.height

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let position = geometry.frame(in: CoordinateSpace.global).midY
            ZStack {
                Color.clear
                if height >= (position + positionOffset)  {
                    content
                }
            }
        }
    }
}
