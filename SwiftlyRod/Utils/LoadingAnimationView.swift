//
//  LoadingView.swift
//  Sw iftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime


struct LoadingAnimation: View {
    private let loaderAnimation = RiveViewModel(fileName: "runner")
    
    var body: some View {
        loaderAnimation.view()
            .frame(width: 200, height: 200) // Adjust as needed
            .onAppear {
                loaderAnimation.play()
            }
            .padding()
    }
}


struct LoadingAnimationView: View {
    var token: OAuthToken?
    @State private var scale: CGFloat = 1.0  // Image scaling state
    @State private var duration: Double = 0.3 // Initial animation duration
    @State private var loadingAnimation = RiveViewModel(fileName: "runner")
    
    @State private var isTransitioning = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.topColor,.centerColor,.bottomColor]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                Image("strava_title")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    .scaleEffect(0.9)
                
                if isTransitioning {
                    MainTabView(token: token)
                        .mask(CircleMaskView())
                        .animation(.easeInOut(duration: 1.0), value: isTransitioning)
                } else {
                    
                    loadingAnimation.view()
                        .scaleEffect(scale) // Correctly applying the scale state
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                animateScaling()
                            }
                            
                        }
                }
            }
        }
    }

    func animateScaling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: duration)) {
                if scale == 1.0 {
                    scale = 1.1
                    scale = 1.35
                } else {
                    scale = 0.0  // Shrink to zero before transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isTransitioning = true // Transition after shrink completes
                    }
                    return // Stop recursive animation
                }
            }
            duration += 0.2 // Increase duration over time
            animateScaling() // Recursively call animation function
        }
    }
}

struct CircleMaskView: View {
    @State private var scale: CGFloat = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .frame(width: scale * geometry.size.width, height: scale * geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scale = 5
                    }
                }
        }
    }
}

//
//struct LoadingRunnerView: View {
//    var runningState: Bool = false
//    @State private var scale: CGFloat = 1.0  // Image scaling state
//    @State private var duration: Double = 0.3 // Initial animation duration
//    @State private var loadingAnimation = RiveViewModel(fileName: "runner_character", stateMachineName: "State Machine 1")
//    
//    @State private var isTransitioning = false
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                LinearGradient(gradient: Gradient(colors: [.topColor,.centerColor,.bottomColor]),
//                               startPoint: .topLeading,
//                               endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
//                
////                Image("strava_title")
////                    .resizable()
////                    .scaledToFit()
////                    .padding()
////                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
////                    .scaleEffect(0.9)
//                
//                if isTransitioning {
//                    MainTabView()
//                        .mask(CircleMaskView())
//                        .animation(.easeInOut(duration: 1.0), value: isTransitioning)
//                } else {
//                    
//                    loadingAnimation.view()
//                        .onAppear {
//                            loadingAnimation.setInput("isRunning", value: runningState)
//                        }
//                }
//            }
//        }
//    }
//}
