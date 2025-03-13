//
//  LoadingView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime

struct LoadingAnimation: View {
    private let loaderAnimation = RiveViewModel(fileName: "loader_animation")
    
    var body: some View {
        loaderAnimation.view()
            .frame(width: 200, height: 200) // Adjust as needed
            .onAppear {
                loaderAnimation.play()
            }
            .padding()
    }
}
