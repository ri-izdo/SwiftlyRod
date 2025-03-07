//
//  SwiftlyRodApp.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/6/25.
//

import SwiftUI
import StravaSwift

@main
struct StravaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if let token = StravaClient.sharedInstance.token {
                MainTabView(token: token)
            } else {
                AuthView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let strava: StravaClient

    override init() {
        let config = StravaConfig(
            clientId: 150395,
            clientSecret: "6c0c5ae5f08d52c6cbc68bd8aa0206963c64759c",
            redirectUri: "swiftlyrod://rodericklizardo.com",
            scopes: [.profileReadAll, .activityReadAll, .activityWrite] // Ensure profileReadAll is included
        )
        strava = StravaClient.sharedInstance.initWithConfig(config)

        super.init()
        print("✅ StravaClient initialized with scopes: \(config.scopes)")
    }



    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("🔄 Received Redirect: \(url.absoluteString)")

        let handled = StravaClient.sharedInstance.handleAuthorizationRedirect(url)

        if handled {
            print("✅ Successfully handled Strava Redirect")
        } else {
            print("❌ Strava Redirect NOT handled")
        }

        return handled
    }




}


struct AuthView: View {
    @State private var isLoading = false
    @State private var token: OAuthToken?
    @State private var athlete: Athlete? // Store athlete separately
    @State private var navigateToMain = false
    @State private var errorMessage: AuthError?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Logging in...")
                    .padding()
            } else {
                Button("Login with Strava") {
                    login()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(Capsule())
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


struct MainTabView: View {
    var token: OAuthToken?// Receive athlete separately

    var body: some View {
        TabView {
            AthleteView(token: token)
                .tabItem {
                    Label("Athlete", systemImage: "person.circle")
                }
            Text("Activities") // Placeholder for additional views
                .tabItem {
                    Label("Activities", systemImage: "bicycle")
                }
        }
    }
}


import SwiftUI

struct AthleteView: View {
    var token: OAuthToken?

    var body: some View {
        VStack {
            if let token = token {
                let firstname = token.athlete?.firstname ?? ""
                let lastname = token.athlete?.lastname ?? ""
                Text("Welcome, \(firstname) \(lastname)")
                    .font(.title)
                    .padding()
            } else {
                Text("Loading athlete data...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}




struct AuthError: Identifiable {
    let id = UUID() // Unique identifier for the alert
    let message: String
}
