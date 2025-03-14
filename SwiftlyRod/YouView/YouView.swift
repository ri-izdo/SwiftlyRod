//
//  YouView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//
//

import SwiftUI
import StravaSwift
import SplineRuntime

struct YouView: View {
    var token: OAuthToken?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Static Custom Color Gradient Background
                let url = URL(string: "https://build.spline.design/8oqdq4W6DqdFPuGv8mxS/scene.splineswift")!
                SplineView(sceneFileURL: url).ignoresSafeArea(.all)
                    .edgesIgnoringSafeArea(.all)
                    .brightness(-0.3)
                VStack {
                    YouAwardView()
                }
            }
        }
    }
}
