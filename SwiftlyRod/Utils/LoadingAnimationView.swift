//
//  LoadingView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime

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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 252/255, green: 76/255, blue: 2/255), // FC4C02
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
//            Rectangle()
//                .fill(Color.black)
//                .fill(Color(hex: "FC4C02"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            if isTransitioning {
                MainTabView()
                    .mask(CircleMaskView())
                    .animation(.easeInOut(duration: 1.0), value: isTransitioning)
            } else {
                loadingAnimation.view()
                    .scaleEffect(scale) // Correctly applying the scale state
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            animateScaling()
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


struct GradualScalingImage: View {
    @State private var scale: CGFloat = 1.0  // Image scaling state
    @State private var duration: Double = 0.3 // Initial animation duration
    @State private var loadingAnimation = RiveViewModel(fileName: "runner")
    
    @State private var isTransitioning = false
    
    var body: some View {
        ZStack {
            if isTransitioning {
                Text("Hi")
            } else {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 252/255, green: 76/255, blue: 2/255), // FC4C02
                            Color.black
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    loadingAnimation.view()
                        .scaleEffect(scale) // Correctly applying the scale state
                    //                    .onAppear {
                    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //                            animateScaling()
                    //                        }
                    
                    //             }
                }
            }
        }
    }

//    func animateScaling() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//            withAnimation(.easeInOut(duration: duration)) {
//                if scale == 1.0 {
//                    scale = 1.1
//                    scale = 1.5
//                } else {
//                    scale = 0.0  // Shrink to zero before transition
//                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//                        isTransitioning = true // Transition after shrink completes
//                    }
//                    return // Stop recursive animation
//                }
//            }
//            duration += 0.2 // Increase duration over time
//            animateScaling() // Recursively call animation function
//        }
//    }
}
