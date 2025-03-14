//
//  StatsView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//
//

import SwiftUI
import StravaSwift
import SplineRuntime

struct AwardView: View {
    @State private var showSpline1 = false // Tracks first Spline visibility
    @State private var showSpline2 = false // Tracks second Spline visibility
    @State private var selectedButton: Int? = nil

    let buttonCount = 12 // Number of buttons

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            // Static Custom Color Gradient Background (#FC4C01 and Black)
            LinearGradient(
                gradient: Gradient(colors: [Color("#FC4C01"), Color.gray ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                // Awards Title Positioned Top-Left
                Text("Awards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                
                // Button Grid
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<buttonCount, id: \.self) { index in
                        Button(action: {
                            if index == 0 {
                                showSpline1.toggle() // Toggle Spline Object #1
                                showSpline2 = false  // Ensure only one is shown
                            } else if index == 1 {
                                showSpline2.toggle() // Toggle Spline Object #2
                                showSpline1 = false  // Ensure only one is shown
                            } else {
                                selectedButton = selectedButton == index ? nil : index
                            }
                        }) {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(
                                    selectedButton == index
                                    || (index == 0 && showSpline1)
                                    || (index == 1 && showSpline2)
                                    ? Color.gray.opacity(0.5)
                                    : Color.gray.opacity(0.3)
                                )
                                .cornerRadius(10)
                                .animation(.easeInOut(duration: 0.2), value: selectedButton)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .blur(radius: showSpline1 || showSpline2 ? 10 : 0) // Blur when any Spline is visible
            .animation(.easeInOut(duration: 0.3), value: showSpline1 || showSpline2)

            // Spline 3D Scene - First Button (Top Left)
            if showSpline1 {
                SplineOverlayView(url: "https://build.spline.design/g6XWPd02qoHtDu1FN9k1/scene.splineswift", onClose: {
                    showSpline1 = false
                })
            }

            // Spline 3D Scene - Second Button (Second from Top Left)
            if showSpline2 {
                SplineOverlayView(url: "https://build.spline.design/9MLYzyhV1UEct61txniX/scene.splineswift", onClose: {
                    showSpline2 = false
                })
            }
        }
        .edgesIgnoringSafeArea(.all) // Full-screen effect
    }
}

// Reusable View for Spline Overlay
struct SplineOverlayView: View {
    let url: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            // Dim background when Spline is active
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onClose()
                }

            VStack {
                let sceneURL = URL(string: url)!
                SplineView(sceneFileURL: sceneURL) // Fixed SplineView initialization
                    .frame(width: 450, height: 450)
                    .cornerRadius(20)
                    .padding()
            }
        }
        .transition(.opacity) // Smooth fade-in effect
    }
}

// Extension to Use Hex Colors in SwiftUI
extension Color {
    init(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
