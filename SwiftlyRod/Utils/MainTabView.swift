//
//  MainTabView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift


struct MainTabView: View {
    var token: OAuthToken?// Receive athlete separately

    var body: some View {
        TabView {
            ActivitiesView(token: token) // Placeholder for additional views
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            StatsView(token: token) // Placeholder for additional views
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
        }
        .tint(.orange)
    }
}
