//
//  WorkoutCard.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//

import Foundation
import SwiftUI

struct WorkoutCard: View {
    var workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(spacing: 16) {
                HStack {
                    Text(workout.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack {
                    Text(workout.date.formatWorkoutDate())
                    
                    Spacer()
                    
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(workout: Workout(title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: Date(), calories: "512 kcal"))
    }
}
