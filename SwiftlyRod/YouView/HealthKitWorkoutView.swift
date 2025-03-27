//
//  HealthKitWorkoutView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/27/25.
//

import Foundation
import SwiftUI

struct HealthKitWorkoutView: View {
    @StateObject var hkHomeViewModel = HomeViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !hkHomeViewModel.homeViewActivity.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(hkHomeViewModel.homeViewActivity.prefix(hkHomeViewModel.showAllActivities == true ? 8 : 4), id: \.title) { activity in
                            ActivityCard(activity: activity)
                            
                        }
                        .frame(width: geometry.size.width * 0.45)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }

                }
                

            }
            
        }
    }
}
