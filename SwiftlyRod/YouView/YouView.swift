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
    
    @State private var isMedal1 = false
    @State private var isMedal2 = false
    @State private var isMedal3 = false

    @State var medal_1URL = "https://build.spline.design/9MLYzyhV1UEct61txniX/scene.splineswift"
    @State var medal_2URL = "https://build.spline.design/ooCbqutT8QTK99oN7382/scene.splineswift"
    @State var medal_3URL = "https://build.spline.design/VTSOhbTSgfFNMT0HpX26/scene.splineswift"
    
    @State var medalName: String = ""
    @State var caption: String = ""

    @State private var medal1Frame: CGRect = .zero
    @State private var medal2Frame: CGRect = .zero
    @State private var medal3Frame: CGRect = .zero
    @State private var showSpline = false
    @State private var splineScale: CGFloat = 0.1
    @State private var splineOpacity: Double = 0.0
    @State private var splineStartPosition: CGPoint = .zero
    @State private var splineEndPosition: CGPoint = .zero
    @State private var activeSplineURL: String = ""
    
    
    @State var viewWidth: CGFloat = 0.0
    @State var viewHeight: CGFloat = 0.0
    @State var viewcenterPosition: CGPoint = .zero
    
    @State private var showTitle = false
    @State private var showAwardSection = false
    @State private var showWalkSection = false
    @State private var showGoalsSection = false
    
    @State private var animationDuration = 0.0
    

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color(hex: "201713")
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        HStack {
                            Text("You")
                                .font(Font.custom("SF Pro", size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .opacity(showTitle ? 1 : 0)
                                .animation(.easeIn(duration: animationDuration), value: showTitle)
                        }
                        awardSection()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .cornerRadius(20)
                            .opacity(showAwardSection ? 1 : 0)
                            .animation(.easeIn(duration: animationDuration), value: showAwardSection)
                        
                        GoalBarView()
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .cornerRadius(20)
                            .opacity(showGoalsSection ? 1 : 0)
                            .animation(.easeIn(duration: animationDuration), value: showGoalsSection)
                        
                        WalkStatsView()
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .cornerRadius(20)
                            .opacity(showWalkSection ? 1 : 0)
                            .animation(.easeIn(duration: animationDuration), value: showWalkSection)
                        
                    }
                    .blur(radius: showSpline ? 10 : 0)
                    .padding(.horizontal, 10)
                    
                    if showSpline {
                        SplineOverlayView(
                            url: activeSplineURL,
                            onClose: {
                                closeSpline()
                            },
                            startPosition: splineStartPosition,
                            endPosition: viewcenterPosition, // Make sure it centers
                            width: self.viewWidth,
                            height: self.viewHeight,
                            scale: splineScale,
                            opacity: splineOpacity,
                            medalName: medalName,
                            caption: caption
                        )
                    }
                }
            }
            .onAppear {
                resetAndAnimateSections()
            }
        }
    }

    func awardSection() -> some View {
        GeometryReader { geometry in
            let heightSpec: CGFloat = 250
            let imageSize = min(geometry.size.width, heightSpec) * 0.3

            VStack {
                VStack {
                    Text("Awards")
                        .font(Font.custom("SF Pro", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.white)
                        .offset(y: -15)
                }
                .offset(y: -20)

                HStack {
                    Spacer()
                    MedalButton(imageName: "medal_1", text: "Run Challenge", imageSize: imageSize) {
                        animateSpline(from: medal1Frame, url: medal_1URL, moveToCenter: true, center: self.viewcenterPosition)
                        medalName = "Run Challenge"
                        caption = "You earned this award for completing a run."
                    }
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: Medal1PositionKey.self, value: geo.frame(in: .global))
                    })
                    Spacer()

                    MedalButton(imageName: "medal_2", text: "Walk Challenge", imageSize: imageSize) {
                        animateSpline(from: medal2Frame, url: medal_2URL, moveToCenter: true, center: self.viewcenterPosition)
                        medalName = "Walk Challenge"
                        caption = "You earned this award for completing a walk."
                    }
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: Medal2PositionKey.self, value: geo.frame(in: .global))
                    })
                    Spacer()

                    MedalButton(imageName: "medal_3", text: "Test Challenge", imageSize: imageSize) {
                        animateSpline(from: medal3Frame, url: medal_3URL, moveToCenter: true, center: self.viewcenterPosition)
                        medalName = "Prototype Challenge"
                        caption = "You earned this award for building a prototype."
                    }
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: Medal3PositionKey.self, value: geo.frame(in: .global))
                    })
                    Spacer()
                }
                .offset(y: -10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.3))
            .onAppear {
                self.viewWidth = geometry.size.width
                self.viewHeight = geometry.size.height
                self.viewcenterPosition = CGPoint(x: self.viewWidth / 2, y: self.viewHeight / 2)
            }
        }
    }


    func animateSpline(from frame: CGRect, url: String, moveToCenter: Bool, center: CGPoint) {
        activeSplineURL = url
        splineStartPosition = CGPoint(x: frame.midX, y: frame.midY)

        withAnimation(.easeInOut(duration: 0.3)) {
            showSpline = true // Ensure state is updated before animation starts
            splineOpacity = 0.0
            splineScale = 0.1 // Ensure starts small
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.8)) {
                splineScale = 1.2
                splineOpacity = 1.0
            }
        }
    }

    func closeSpline() {
        withAnimation(.easeInOut(duration: 0.5)) {
            splineScale = 0.1
            splineOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showSpline = false
        }
    }
    
    // 🔄 Reset animations and restart transitions
    func resetAndAnimateSections() {
        resetAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animationDuration = 1.0
            showAwardSection = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showGoalsSection = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showWalkSection = true
                    showTitle = true
                }
            }
        }
    }

    // ❌ Reset animation states when leaving the tab
    func resetAnimations() {
        splineScale = 0.1
        splineOpacity = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            animationDuration = 0.0
            showAwardSection = false
            showWalkSection = false
            showGoalsSection = false
            showTitle = false


        }
    }
}


// MARK: - Medal Button Component
struct MedalButton: View {
    let imageName: String
    let text: String
    let imageSize: CGFloat
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .offset(y: -5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
struct SplineOverlayView: View {
    let url: String
    let onClose: () -> Void
    var startPosition: CGPoint
    var endPosition: CGPoint
    var width: CGFloat
    var height: CGFloat
    var scale: CGFloat
    var opacity: Double
    var medalName: String
    var caption: String
    @State private var showText: Bool = false
    @State private var animationDuration = 0.0

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        animationDuration = 1.0
                        showText = false
                    }
                    onClose()
                }
            
            VStack {
                let sceneURL = URL(string: url)!
                
                SplineView(sceneFileURL: sceneURL)
                    .cornerRadius(20)
                    .scaleEffect(0.95)
                    .opacity(opacity)
                    .offset(y: height * 0.05) // Move slightly down for centering
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            animationDuration = 1.5
                            showText = true
                        }
                        
                    }
                    .onDisappear {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            animationDuration = 1.0
                            showText = false
                        }
                    }
                
                VStack {
                    Text(medalName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.top, 10)
                    
                    Text(caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 14))
                }
                .transition(.opacity)
                .offset(y:-200)
                .opacity(showText ? 1 : 0)
                .animation(.easeIn(duration: animationDuration), value: showText)
                //            .frame(maxWidth: .infinity, maxHeight: height * 0.9)
            }
            .transition(.opacity)
            //        .frame(maxWidth: .infinity, maxHeight: height)
        }
    }
}






// MARK: - PreferenceKeys for Medal Positions
struct Medal1PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

struct Medal2PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

struct Medal3PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}
