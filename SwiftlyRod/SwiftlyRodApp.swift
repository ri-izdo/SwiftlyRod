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
//            if let token = StravaClient.sharedInstance.token {
//                LoadingAnimationView(token: token)
//            } else {
            SplashView()
//                YouView()
//            }
        }
    }
}
