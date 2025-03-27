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
    @State private var selectedTab = 1
    @State private var stateMachine: String = "State Machine 1"

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CelebrationView()
                    .tag(0)
                YouView(token: token)
                    .tag(1)
                WorkoutTabView(token: token)
                    .tag(2)
                StravaActivitiesView(token: token)
                    .tag(3)
            }
            .background(Color.gray.opacity(0.3))
//            .tabViewStyle(PageTabViewStyle())
            
            HStack {
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 0, riveFile: "home_icon", stateMachine: stateMachine, text: "Celebrations")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 1, riveFile: "usericon", stateMachine: stateMachine, text: "You")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 2, riveFile: "restart_icon", stateMachine: stateMachine, text: "Workouts")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 3, riveFile: "social_icon", stateMachine: stateMachine, text: "Activities")
                Spacer()
            }
        }
//        .onAppear {
//            if selectedTab != 2 {
//                YouView().resetAnimations()
//            }
//        }
    }
}
