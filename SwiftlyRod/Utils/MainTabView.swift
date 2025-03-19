//
//  MainTabView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift
import RiveRuntime


struct MainTabView: View {
    var token: OAuthToken?
    @State private var selectedTab = 2
    @State private var stateMachine: String = "State Machine 1"

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                SplashView()
                    .tag(0)
                ActivitiesView(token: token)
                    .tag(1)
                YouView(token: token)
                    .tag(2)
            }
            .background(Color.gray.opacity(0.3))
            
            HStack {
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 0, riveFile: "restart_icon", stateMachine: stateMachine, text: "Splash")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 1, riveFile: "home_icon", stateMachine: stateMachine, text: "Home")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 2, riveFile: "usericon", stateMachine: stateMachine, text: "You")
                Spacer()
            }
        }
    }
}
