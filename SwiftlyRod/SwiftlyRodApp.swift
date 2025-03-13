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
