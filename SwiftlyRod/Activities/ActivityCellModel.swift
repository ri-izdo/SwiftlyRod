//
//  ActivityCellModel.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//

import SwiftUI
import StravaSwift
import Foundation


struct ActivityCellModel: View {
    var activity: Activity
    var token: OAuthToken?
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            VStack {
                header(token: token, activity: activity)
                
            }
        }
    }
    
    /// Formats the activity date to show only the month name.
    func activityDate() -> some View {
        if let date = activity.startDate {
            return Text("\(date, style: .date)")
        } else {
            return Text("")
        }
    }
    
    func header(token: OAuthToken?, activity: Activity) -> some View {
        let firstName = token?.athlete?.firstname ?? "Unknown"
        let lastName = token?.athlete?.lastname ?? ""

        return HStack {
            VStack {
                Text("\(firstName) \(lastName)")
                activityDate()
            }
            Spacer()
        }
    }
}
