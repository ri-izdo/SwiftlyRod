//
//  ActivitiesView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift
import SplineRuntime

struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel()
    @State private var selectedActivity: Activity?
    
    var token: OAuthToken?
    

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingAnimation()
                } else if viewModel.activities.isEmpty {
                    Text("⚠️ No Activities Found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ZStack {
                        List(viewModel.activities) {
                            activity in
                            Button {
                                selectedActivity = activity
                            } label: {
                                ActivityCellModel(
                                    activity: activity,
                                    token: token
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear) // Prevents system background
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Activities")
            .onAppear {
                viewModel.fetchActivities()
            }
            .navigationDestination(item: $selectedActivity) { activity in
                ActivityDetailView(activity: activity)
            }
        }
    }
}
