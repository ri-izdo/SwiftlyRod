//
//  AuthView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime


struct AuthView: View {
    @State private var isLoading = false
    @State private var token: OAuthToken?
    @State private var athlete: Athlete? // Store athlete separately
    @State private var navigateToMain = false
    @State private var errorMessage: AuthError?
    private let solarAnimation = RiveViewModel(fileName: "solar_system_animation")
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingAnimation()
            } else {
                VStack {
                    solarAnimation.view()
                        .frame(width: 200, height: 200) // Adjust as needed
                        .onAppear {
                            solarAnimation.play()
                        }
                    Button("Login with Strava") {
                        login()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToMain) {
            if let token = token {
                MainTabView(token: token)
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
