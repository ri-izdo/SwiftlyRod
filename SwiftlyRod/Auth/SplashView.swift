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
import SwiftUIX

class SplashViewModel: ObservableObject {
    @Published var usePaging: Bool = true
}

struct SplashView: View {
    @State private var selection = 0

    @State private var token: OAuthToken?
    @State private var athlete: Athlete? // Store athlete separately
    @State private var navigateToMain = false
    @State private var errorMessage: AuthError?
    @State private var blurAmount: CGFloat = 0.0
//    @State private let splashScreen = RiveViewModel(fileName: "splash_screen", stateMachineName: "workout")
    @State private var scale: CGFloat = 1.0  // Image scaling state
    @State private var duration: Double = 0.3 // Initial animation duration
    @State private var isTransitioning = false
    @State private var showMaskTransition = false
    @State private var loadingAnimation = RiveViewModel(fileName: "runner_character", stateMachineName: "State Machine 1")
    @State var isLoading = false
    @State private var isReady = false
    @State private var isGlowing = false
    @State var isLocked = false
    @GestureState private var isPressed = false
    @State var usePaging = false
    
    @State private var loginText = ""
    @State private var buttonActive = false
    @State private var isContinue = false
    @State private var loginButton = RiveViewModel(fileName: "login_buttonSTART", stateMachineName: "State Machine 1")
    @State private var loginButtonOpacity = 0.0
    
    @StateObject var splashViewModel = SplashViewModel()

    
    var body: some View {

        
        GeometryReader { geometry in
            VStack {
                if isLoading {
                    ZStack {
                        Rectangle()
                            .fill(.black)
                        ProgressView()
                    }
                } else {
                    if splashViewModel.usePaging {
                        ZStack {
                            TabView(selection: $selection) {
                                CardView(selection: selection).tag(0)
                                CardView(selection: selection).tag(1)
                                CardView(selection: selection).tag(2)
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                ZStack {
                                    FaceGraphic(selection: $selection)
                                    Blob1Graphic(selection: $selection)
                                    Blob2Graphic(selection: $selection)
                                        .blur(radius: 10)
                                }
                            )
                            
                            if selection == 2 {
                                ZStack {
                                    loginButton.view()
                                        .opacity(loginButtonOpacity)
                                        .scaleEffect(1.2)
                                        .onAppear {
                                            loginButton.setInput("active", value: false)
                                            
                                        }
            
                                    
                                    
                                    
                                    if !buttonActive || token == nil {
                                        Button(loginText) {
                                            loginButton.setInput("active", value: true)
                                            isContinue = true
                                            loginText = ""
                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                login()
                                            }
                                        }
                                        .opacity(loginButtonOpacity)
                                        .foregroundColor(.white)
                                        .onAppear {
                                            if !isContinue {
                                                withAnimation(.easeIn(duration: 1.0)) {
                                                    loginText = "CONTINUE"
                                                    loginButtonOpacity = 1.0
                                                }
                                                
                                            } else {
                                                loginText = "CONTINUE"
                                                loginButton.setInput("active", value: false)
                                                
                                            }
                                        }
                                    }
                                }
                                .offset(y:350)
                                .onChange(of: isContinue) {
                                    loginText = "CONTINUE"
                                    loginButton.setInput("active", value: false)
                                }
                            }
                            
                        }
                    }

//                    ZStack {
//                        
//                        LinearGradient(gradient: Gradient(colors: [.topColor,.centerColor,.bottomColor]),
//                                       startPoint: .topLeading,
//                                       endPoint: .bottom)
//                        .edgesIgnoringSafeArea(.all)
//                        
//                        
//                        
//                        loadingAnimation.view()
//                            .onAppear {
//                                loadingAnimation.setInput("isRunning", value: false)
//                            }
//                        
//                        Image("strava_title")
//                            .resizable()
//                            .scaledToFit()
//                            .padding()
//                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
//                            .scaleEffect(0.9)
//                            .offset(y:-650)
//                        
//                        if isReady {
//                            Text("Get Started to join!")
//                                .font(.system(size: 16, weight: .bold)) // Match text style
//                                .foregroundColor(.white)
//                                .offset(y:-200)
//                            Button("Get Started!") {
//                                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                                    login()
//                                }
//                            }
//                            .font(.system(size: 16, weight: .bold)) // Match text style
//                            .foregroundColor(.white)
//                            .frame(width: 280, height: 50) // Increase button size
//                            .background(
//                                LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.9), Color(red: 252/255, green: 82/255, blue: 0/255)]),
//                                               startPoint: .topLeading,
//                                               endPoint: .bottomTrailing)
//                            )
//                            .cornerRadius(10) // Rounded edges
//                            .offset(y:300)
//                            .shadow(color: Color.orange.opacity(isGlowing ? 3 : 0.4), radius: isGlowing ? 30 : 10)
//                            .scaleEffect(isPressed ? 0.55 : (isGlowing ? 1.05 : 1.0))
//                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isGlowing)
//                            .animation(.easeInOut(duration: 0.3), value: isPressed)
//                            .gesture(pressGesture)
//                            .onAppear {
//                                isGlowing = true
//                            }
//                        } else {
//                            Text("I'm here to help with your fitness journey.")
//                                .font(.system(size: 16, weight: .bold)) // Match text style
//                                .foregroundColor(.white)
//                                .offset(y:-200)
//                            
//                            Button("Continue") {
//                                isReady = true
//                                
//                            }
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(width: 280, height: 50) // Increase button size
//                            .background(
//                                LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.9), Color(red: 252/255, green: 82/255, blue: 0/255)]),
//                                               startPoint: .topLeading,
//                                               endPoint: .bottomTrailing)
//                            )
//                            .cornerRadius(10)
//                            .offset(y:300)
//                            .shadow(color: Color.orange.opacity(isGlowing ? 3 : 0.4), radius: isGlowing ? 30 : 10)
//                            .scaleEffect(isPressed ? 0.55 : (isGlowing ? 1.05 : 1.0))
//                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isGlowing)
//                            .animation(.easeInOut(duration: 0.3), value: isPressed)
//                            .gesture(pressGesture)
//                            .onAppear {
//                                isGlowing = true
//                            }
//                        }
//                    }
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


import SwiftUIX
struct CardView: View {
    var selection: Int?
    @State private var token: OAuthToken?
    @State private var athlete: Athlete? // Store athlete separately
    @State private var navigateToMain = false
    @State private var errorMessage: AuthError?
    @State private var bodyBlurb: String = ""
    @State private var titleText: String = ""
    @State private var titleText_0  = "Explore. \nTranslate. \nMove."
    @State private var titleText_1 = "Community. \nGrowth. \nMotivate."
    @State private var titleText_2 = "Running. \nBiking. \nHiking."
    @State private var animate = false
    
    @State private var color0_0 = Color(#colorLiteral(red: 0.01151172072, green: 0.05182617158, blue: 0.318133682, alpha: 1))
    @State private var color0_1 = Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))
    @State private var color0_2 = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    
    @State private var color1_0 = Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
    @State private var color1_1 = Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
    @State private var color1_2 = Color(#colorLiteral(red: 0.5711023808, green: 0.4489779472, blue: 1, alpha: 1))
    
    @State private var color2_0 = Color(#colorLiteral(red: 1, green: 0.6041869521, blue: 0.3433918357, alpha: 1))
    @State private var color2_1 = Color(#colorLiteral(red: 1, green: 0.3883444667, blue: 0.2500864267, alpha: 1))
    @State private var color2_2 = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    
    @State private var color0 = Color(#colorLiteral(red: 0.01151172072, green: 0.05182617158, blue: 0.318133682, alpha: 1))
    @State private var color1 = Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))
    @State private var color2 = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    
    let blurb_0 = "A prototype built to explore ideas, translate complexity into clarity, and embody the spirit of motion and progress."
    let blurb_1 = "Designed to help users better understand their habits, celebrate their progress, and stay motivated on their journey."
    let blurb_2 = "Visual data is precise and purposeful, so you can focus on what matters most: your progress."
    
    @StateObject var splashViewModel = SplashViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Strava + HealthKit".uppercased())
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white.opacity(0.7))
                        
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: color0, location: 0),
                                .init(color: color1, location: 0.5629924535751343),
                                .init(color: color2, location: 1)]),
                            startPoint: animate ? UnitPoint(x: 1, y: 1) : UnitPoint(x: 1.0125392039427847, y: 1.0175438863216821),
                            endPoint: animate ? UnitPoint(x: 0, y: 0) : UnitPoint(x: 1, y: 1)
                        )
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                        .frame(maxHeight: 160)
                        .mask(Text(titleText)
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading))
                        Text(bodyBlurb)
                            .font(.subheadline)
                            .foregroundColor(Color.white.opacity(0.8))
                        
                    }
                    .padding(30)
                    .background(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0.14509804546833038, green: 0.12156862765550613, blue: 0.2549019753932953, alpha: 1)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0.14509804546833038, green: 0.12156862765550613, blue: 0.2549019753932953, alpha: 0)), location: 1)]),
                        startPoint: UnitPoint(x: 0.49999988837676157, y: 2.9497591284275417e-15),
                        endPoint: UnitPoint(x: 0.4999999443689973, y: 0.9363635917143408)))
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.2), Color.white.opacity(0)]), startPoint: .top, endPoint: .bottom), lineWidth: 1)
                            .blendMode(.overlay)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.2), Color.white.opacity(0)]), startPoint: .top, endPoint: .bottom), lineWidth: 1)
                                    .blur(radius: 8)
                            )
                    )
                    .padding(20)
                }
                .onAppear {
                    titleText = titleText_0
                    bodyBlurb = blurb_0
                    animate = true
                    color0 = color0_0
                    color1 = color0_1
                    color2 = color0_2
                    
                }
                .onChange(of: selection) {
                    if selection == 0 {
                        titleText = titleText_0
                        bodyBlurb = blurb_0
                        color0 = color0_0
                        color1 = color0_1
                        color2 = color0_2
                        
                    } else if selection == 1 {
                        titleText = titleText_1
                        bodyBlurb = blurb_1
                        color0 = color1_0
                        color1 = color1_1
                        color2 = color1_2
                    } else if selection == 2 {
                        titleText = titleText_2
                        bodyBlurb = blurb_2
                        color0 = color2_0
                        color1 = color2_1
                        color2 = color2_2
                    }
                }
                .frame(height: 500)
                .background(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0.15701383352279663, green: 0.10772569477558136, blue: 0.3541666567325592, alpha: 0)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0.15701383352279663, green: 0.10772569477558136, blue: 0.3541666567325592, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 0.5, y: 0.30500000480115429),
                    endPoint: UnitPoint(x: 0.5, y: 1.0000000400096194)))
                .mask(RoundedRectangle(cornerRadius: 30))
                .padding(8)
                
                
                
                    
                
            }
        }
    }
}
