//
//  DailyActivityView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//

import Foundation
import SwiftUI

struct DailyActivityView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @State private var showAllActivities = true
    @State private var showDetail = true
    var body: some View {
        GeometryReader { geometry in
            if !homeViewModel.homeViewActivity.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 1), count: 1)) {
                    ForEach(homeViewModel.homeViewActivity.prefix(homeViewModel.showAllActivities == true ? 1 : 1), id: \.title) { activity in
                        ActivityCard(activity: activity)
                    
                    }
                }
            }
        }
    }
}
