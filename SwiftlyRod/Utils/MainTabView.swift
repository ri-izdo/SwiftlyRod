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
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ActivitiesView(token: token)
                    .tag(0)
                AwardView(token: token)
                    .tag(1)
            }
            .background(Color.gray.opacity(0.2))
            
            HStack {
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 0, riveFile: "home_icon", stateMachine: "State Machine 1", text: "Home")
                Spacer()
                TabButton(selectedTab: $selectedTab, tab: 1, riveFile: "usericon", stateMachine: "State Machine 1", text: "You")
                Spacer()
            }
        }
    }
}
