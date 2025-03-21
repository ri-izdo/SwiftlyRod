//
//  AuthView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime
import SplineRuntime


//struct LoadingView: View {
//    @State private var isLoading = true
//    @State private var animateTransition = false
//    @State private var loadingAnimation = RiveViewModel(fileName: "LoadAnimation")
//    @State private var showMaskTransition = false
//    
//    var body: some View {
//        ZStack {
//            if isLoading {
//                loadingAnimation.view()
//                    .scaleEffect(scale)
//                    .mask(showMaskTransition ? AnyView(CircleMaskView()) : AnyView(Rectangle()))
//                    .animation(.easeInOut(duration: 1.0), value: showMaskTransition)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            // Trigger mask animation
//                            withAnimation {
//                                showMaskTransition = true
//                            }
//                            
//                            // Delay login until after animation
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                login()
//                            }
//                        }
//                    }
//            } else {
//                SplashView()
//                    .transition(.asymmetric(insertion: .scale(scale: 0.1).combined(with: .opacity), removal: .scale(scale: 1.5).combined(with: .opacity)))
//            }
//        }
//        .animation(.easeInOut, value: isLoading)
//    }
//}



struct SplashView: View {
    @State private var isLoading = false
    @State private var token: OAuthToken?
    @State private var athlete: Athlete? // Store athlete separately
    @State private var navigateToMain = false
    @State private var errorMessage: AuthError?
    @State private var blurAmount: CGFloat = 0.0
    private let splashScreen = RiveViewModel(fileName: "splash_screen", stateMachineName: "workout")
    @State private var scale: CGFloat = 1.0  // Image scaling state
    @State private var duration: Double = 0.3 // Initial animation duration
    @State private var isTransitioning = false
    @State private var showMaskTransition = false
    @State private var loadingAnimation = RiveViewModel(fileName: "runner_character", stateMachineName: "State Machine 1")
    
    @State private var isReady = false
    @State private var isGlowing = false
    @GestureState private var isPressed = false
    
    var body: some View {
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isPressed) { _, state, _ in
                state = true
            }
        
        GeometryReader { geometry in
            VStack {
                if isLoading {
                    ZStack {
                        Rectangle()
                            .fill(.black)
                        ProgressView()
                    }
                } else {
                    ZStack {
                        
                        LinearGradient(gradient: Gradient(colors: [.topColor,.centerColor,.bottomColor]),
                                       startPoint: .topLeading,
                                       endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                        
                        
                        
                        loadingAnimation.view()
                            .onAppear {
                                loadingAnimation.setInput("isRunning", value: isReady)
                            }
                        
                        Image("strava_title")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                            .scaleEffect(0.9)
                            .offset(y:-650)
                        
                        if isReady {
                            Text("Press Get Started to join!")
                                .font(.system(size: 16, weight: .bold)) // Match text style
                                .foregroundColor(.white)
                                .offset(y:-200)
                            Button("Get Started!") {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    login()
                                }
                            }
                            .font(.system(size: 16, weight: .bold)) // Match text style
                            .foregroundColor(.white)
                            .frame(width: 280, height: 50) // Increase button size
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.9), Color(red: 252/255, green: 82/255, blue: 0/255)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                            .cornerRadius(10) // Rounded edges
                            .offset(y:300)
                            .shadow(color: Color.orange.opacity(isGlowing ? 3 : 0.4), radius: isGlowing ? 30 : 10)
                            .scaleEffect(isPressed ? 0.55 : (isGlowing ? 1.05 : 1.0))
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isGlowing)
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                            .gesture(pressGesture)
                            .onAppear {
                                isGlowing = true
                            }
                        } else {
                            Text("I'm here to help with your fitness journey.")
                                .font(.system(size: 16, weight: .bold)) // Match text style
                                .foregroundColor(.white)
                                .offset(y:-200)
                            
                            Button("Continue") {
                                isReady = true
                                loadingAnimation.setInput("isRunning", value: true)
                                
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 280, height: 50) // Increase button size
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.9), Color(red: 252/255, green: 82/255, blue: 0/255)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                            .cornerRadius(10)
                            .offset(y:300)
                            .shadow(color: Color.orange.opacity(isGlowing ? 3 : 0.4), radius: isGlowing ? 30 : 10)
                            .scaleEffect(isPressed ? 0.55 : (isGlowing ? 1.05 : 1.0))
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isGlowing)
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                            .gesture(pressGesture)
                            .onAppear {
                                isGlowing = true
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $navigateToMain) {
                if let token = token {
                    LoadingAnimationView(token: token)
                }
            }
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Authentication Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
            .onOpenURL { url in
                print("🔄 onOpenURL Received Redirect: \(url.absoluteString)")
                
                let handled = StravaClient.sharedInstance.handleAuthorizationRedirect(url)
                
                if handled {
                    print("✅ Successfully handled Strava Redirect via onOpenURL")
                } else {
                    print("❌ Strava Redirect NOT handled via onOpenURL")
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

    private func login() {
        print("🚀 Login function started")
        isLoading = true

        DispatchQueue.main.async {
            print("📡 Calling Strava authorize() on MAIN thread...")

            StravaClient.sharedInstance.authorize { (result: Result<OAuthToken, Error>) in
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("✅ Strava authorize() completed with result: \(result)")

                    switch result {
                        case .success(let authToken):
                            print("🎉 Authentication Success! Token: \(String(describing: authToken.accessToken))")
                            self.token = authToken
                            self.fetchAthlete()

                        case .failure(let error):
                            print("❌ Authentication Failed: \(error.localizedDescription)")
                            self.errorMessage = AuthError(message: error.localizedDescription)
                    }
                }
            }
        }

        print("📡 Strava authorize() function called")
    }

    private func fetchAthlete() {
        print("🔄 Fetching Athlete Details...")

        StravaClient.sharedInstance.request(Router.athlete, result: { (athlete: Athlete?) in
            DispatchQueue.main.async {
                if let athlete = athlete {
                    print("✅ Athlete Data Received: \(String(describing: athlete.firstname)) \(String(describing: athlete.lastname))")
                    self.athlete = athlete
                    self.navigateToMain = true // Ensure UI updates
                } else {
                    print("⚠️ Athlete Data is Nil")
                    self.errorMessage = AuthError(message: "Failed to fetch athlete data.")
                }
            }
        }, failure: { error in
            DispatchQueue.main.async {
                print("❌ Athlete Fetch Failed: \(error.localizedDescription)")
                self.errorMessage = AuthError(message: error.localizedDescription)
            }
        })
    }
}
