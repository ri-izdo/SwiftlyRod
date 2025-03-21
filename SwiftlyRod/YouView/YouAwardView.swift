//
//  YouAwardView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/14/25.
//
//
//
//import SwiftUI
//import StravaSwift
//import SplineRuntime
//
//

//
//
//
////SplineView(sceneFileURL: url).ignoresSafeArea(.all)
//
//struct YouAwardView: View {
//    @State private var showSpline1 = false
//    @State private var showSpline2 = false
//    @State private var showSpline3 = false
//    @State private var showSpline4 = false
//    @State private var selectedButton: Int? = nil
//    @State private var showAwards: [Bool] = [] // Animation states for each button
//    @State private var showChart = false // ✅ Controls the WalkingChartView fade-in
//    
//    @State var medal_1URL = "https://build.spline.design/9MLYzyhV1UEct61txniX/scene.splineswift"
//    @State var medal_2URL = "https://build.spline.design/IOP9BggddaW5vcvR31IA/scene.splineswift"
//    @State var medal_3URL = "https://build.spline.design/IOP9BggddaW5vcvR31IA/scene.splineswift"
//    
//    let buttonCount = 3 // Number of buttons
//
//    let columns = [
//        GridItem(.flexible()), GridItem(.flexible()),
//        GridItem(.flexible()), GridItem(.flexible())
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                VStack(alignment: .leading) {
//                    Spacer().frame(height: 40)
//
//                    // Awards Title Positioned Top-Left
//                    Text("Awards")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .shadow(radius: 4)
//                        .padding(.leading, 20)
//                        .padding(.top, 20)
//
//                    // Button Grid with Animation
//                    LazyVGrid(columns: columns, spacing: 15) {
//                        ForEach(0..<buttonCount, id: \.self) { index in
//                            Button(action: {
//                                if index == 0 {
//                                    showSpline1.toggle()
//                                    showSpline2 = false
//                                    showSpline3 = false
//                                    showSpline4 = false
//                                } else if index == 1 {
//                                    showSpline2.toggle()
//                                    showSpline1 = false
//                                    showSpline3 = false
//                                    showSpline4 = false
//                                } else if index == 2 {
//                                    showSpline3.toggle()
//                                    showSpline1 = false
//                                    showSpline2 = false
//                                    showSpline4 = false
//                                }  else if index == 3 {
//                                    showSpline4.toggle()
//                                    showSpline1 = false
//                                    showSpline2 = false
//                                    showSpline3 = false
//                                } else {
//                                    selectedButton = selectedButton == index ? nil : index
//                                }
//                            }) {
//                                Rectangle()
//                                    .frame(height: 50)
//                                    .foregroundColor(
//                                        selectedButton == index
//                                        || (index == 0 && showSpline1)
//                                        || (index == 1 && showSpline2)
//                                        || (index == 2 && showSpline3)
//                                        || (index == 3 && showSpline4)
//                                        ? Color.orange.opacity(0.5)
//                                        : Color.gray.opacity(0.3)
//                                    )
//                                    .cornerRadius(10)
//                                    .opacity(showAwards.indices.contains(index) && showAwards[index] ? 1 : 0) // Fade in
//                                    .offset(y: showAwards.indices.contains(index) && showAwards[index] ? 0 : 80) // Slide in
//                                    .scaleEffect(showAwards.indices.contains(index) && showAwards[index] ? 1 : 0.8) // Scale effect
//                                    .rotationEffect(.degrees(showAwards.indices.contains(index) && showAwards[index] ? 0 : 15)) // Rotate in
//                                    .animation(
//                                        .spring(response: 1.0, dampingFraction: 0.6)
//                                        .delay(0.1 * Double(index)), // Staggered delay
//                                        value: showAwards
//                                    )
//                                    .transition(.opacity.combined(with: .move(edge: .bottom))) // Smooth transition
//                            }
//                        }
//                    }
////                    .padding(.horizontal)
//                }
//                .blur(radius: showSpline1 || showSpline2 ? 10 : 0)
//                .animation(.easeInOut(duration: 0.3), value: showSpline1 || showSpline2)
//                
//
//                // Spline 3D Scene - First Button (Top Left)
//                if showSpline1 {
//                    SplineOverlayView(url: medal_1URL, onClose: {
//                        showSpline1 = false
//                    })
//                }
//
//                // Spline 3D Scene - Second Button (Second from Top Left)
//                if showSpline2 {
//                    SplineOverlayView(url: medal_2URL, onClose: {
//                        showSpline2 = false
//                    })
//                }
//                
//                if showSpline3 {
//                    SplineOverlayView(url: medal_3URL, onClose: {
//                        showSpline3 = false
//                    })
//                }
//               
//                if showSpline4 {
//                    SplineOverlayView(url: "https://build.spline.design/D3Wq-Cz97mtLE8sMj7iR/scene.splineswift", onClose: {
//                        showSpline4 = false
//                    })
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//            .onAppear {
//                resetAndAnimateAwards()
//                
//                // ✅ Delay WalkingChartView appearance until animations finish
//                DispatchQueue.main.asyncAfter(deadline: .now() + (0.1 * Double(buttonCount)) + 1.0) {
//                    showChart = true
//                }
//            }
//        }
//    }
//
//    /// Resets the animation and triggers it again on tab switch
//    private func resetAndAnimateAwards() {
//        showAwards = Array(repeating: false, count: buttonCount)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            for index in 0..<buttonCount {
//                DispatchQueue.main.asyncAfter(deadline: .now() + (0.1 * Double(index))) {
//                    showAwards[index] = true
//                }
//            }
//        }
//    }
//}
//
//
//// Reusable View for Spline Overlay
//struct SplineOverlayView: View {
//    let url: String
//    let onClose: () -> Void
//
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.5)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    onClose()
//                }
//
//            VStack {
//                let sceneURL = URL(string: url)!
//                SplineView(sceneFileURL: sceneURL)
//                    .frame(width: 450, height: 450)
//                    .cornerRadius(20)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity) // Centers it in the screen
//        }
//        .transition(.opacity)
//    }
//}
//
