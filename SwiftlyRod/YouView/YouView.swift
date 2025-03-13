//
//  StatsView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift

struct YouView: View {
    var token: OAuthToken?
    
    @StateObject private var activitiesViewModel = ActivitiesViewModel()
    @State private var isWalkingStats = false

    var body: some View {
        NavigationStack {
            VStack {
                activityGroups()
                
                if isWalkingStats {
                    walkingStats()
                }
                Spacer() // Pushes everything else down
            }
            .frame(maxHeight: .infinity, alignment: .top) // Keeps content aligned to the top
            .background(Color.black.ignoresSafeArea()) // Maintains black background
        }
        .navigationTitle("You")
    }
    
    func activityGroups() -> some View {
        return HStack {
            Button(action: {
                toggleSwitch(state: $isWalkingStats)
            }) {
                HStack {
                    Image(systemName: "shoe")
                    Text("Walk")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: 110, maxHeight: 45)
                .foregroundColor(isWalkingStats ? Color.orange : Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isWalkingStats ? Color.orange : Color.gray, lineWidth: 1)
                )
            }
            .padding(.leading, 10) // Adjust left padding
            .padding(.top, 40) // Adjust top padding
            
            Spacer() // Pushes everything to the left
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func walkingStats() -> some View {
        return ZStack {
            Color.gray.opacity(0.2)
            VStack {
                Text("This week")
                    .padding(.leading, 10) // Adjust left padding
                    .padding(.top, 40) // Adjust top padding
            }
        }
    }
    
    func toggleSwitch(state: Binding<Bool>) {
        state.wrappedValue.toggle()
    }
}

struct YouView_Previews: PreviewProvider {
    static var previews: some View {
        YouView()
    }
}
