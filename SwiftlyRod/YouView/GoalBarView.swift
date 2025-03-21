//
//  GoalBarView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/20/25.
//

import SwiftUI
import RiveRuntime

struct GoalBarView: View {
    @State private var sectionRadius: CGFloat = 15.0
    @StateObject var progressRing = RiveViewModel(fileName: "strava_progress_ring", stateMachineName: "State Machine 1")

    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))

                }
            }
        }
    }
}
