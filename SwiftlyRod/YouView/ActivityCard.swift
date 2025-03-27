//
//  ActivityCard.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//

import Foundation
import SwiftUI

struct ActivityCard: View {
    @State var activity: ActivityItems
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        let activityTitle = String(activity.title).replacingOccurrences(of: "Other", with: "High Intensity Interval Training")
                        Text(activityTitle)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                
                Text(activity.amount)
                    .font(.title2)
                    .bold()
                    .padding()
                    .offset(y:-20)
            }
            .padding()
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(activity: ActivityItems(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9,812"))
    }
}
