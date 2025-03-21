//
//  CircleRevealMaskView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/21/25.
//

import SwiftUI

struct CircleRevealMaskView: View {
    @Binding var animate: Bool

    var body: some View {
        GeometryReader { geo in
            Circle()
                .frame(width: animate ? geo.size.height * 2 : 50,
                       height: animate ? geo.size.height * 2 : 50)
                .scaleEffect(animate ? 1.5 : 0.1)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                .animation(.easeInOut(duration: 1.0), value: animate)
        }
    }
}
