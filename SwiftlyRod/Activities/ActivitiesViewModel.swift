//
//  ActivitiesViewModel.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//
//
//import SwiftUI
//import StravaSwift
//
//
//
//class ActivitiesViewModel: ObservableObject {
//    @Published var activities: [Activity] = []
//    @Published var isLoading = false
//
//
//    func fetchActivities(params: Router.Params = nil) {
//        print("🔄 Fetching activities from Strava...")
//        isLoading = true
//        objectWillChange.send() // Force SwiftUI update
//
//        StravaClient.sharedInstance.request(Router.athleteActivities(params: params), result: { [weak self] (response: [Activity]?) in
//            DispatchQueue.main.async {
//                guard let self = self else {
//                    print("⚠️ Self is nil - ViewModel may not exist anymore")
//                    return
//                }
//                
//                self.isLoading = false
//
//                if let activitiesData = response {
//                    self.activities = activitiesData
//                    print(activitiesData)
//                } else {
//                    print("⚠️ No activities returned from API - Empty Response")
//                }
//            }
//        }, failure: { error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                print("❌ API request failed: \(error.localizedDescription)")
//            }
//        }
//        )
//    }
//}
//
