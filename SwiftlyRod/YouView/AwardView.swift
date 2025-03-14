//
//  StatsView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/7/25.
//

import SwiftUI
import StravaSwift
import SplineRuntime


struct AwardView: View {
    var token: OAuthToken?
    
    @StateObject private var activitiesViewModel = ActivitiesViewModel()
    @State private var isWalkingStats = false
    @State private var isBadge = false
    @State private var isMedal = false

    var body: some View {
        VStack {
            HStack {
                Text("Awards")
                    .font(.system(size: 50.0))
                Spacer()
                    .frame(height:50)
            }
            activityButtons()
            if isWalkingStats {
                let url = URL(string: "https://build.spline.design/g6XWPd02qoHtDu1FN9k1/scene.splineswift")!
                SplineView(sceneFileURL: url).ignoresSafeArea(.all)
                    .frame(width: 450, height: 450)
            } else {
                Rectangle()
                    .frame(width: 450, height: 450)
                    .background(Color.black)
                    .opacity(0.0)
            }
        }
//        .frame(maxHeight: .infinity, alignment: .top) // Keeps content aligned to the top
        .background(Color.black.ignoresSafeArea()) // Maintains black background
        
    }
    
    func activityButtons() -> some View {
        return HStack {
            Button(action: {
                toggleSwitch(state: $isMedal)
            }) {
                VStack {
                    HStack {
                        Image(systemName: "medal")
                            .font(.system(size: 50))
                    }
                }
                .foregroundColor(isMedal ? Color.orange : Color.gray)
            }
            
            Button(action: {
                toggleSwitch(state: $isWalkingStats)
            }) {
                VStack {
                    HStack {
                        Image(systemName: "tropicalstorm.circle.fill")
                            .font(.system(size: 50))
                    }
                }
                .foregroundColor(isWalkingStats ? Color.orange : Color.gray)
            }
            Button(action: {
                toggleSwitch(state: $isBadge)
            }) {
                VStack {
                    HStack {
                        Image(systemName: "trophy")
                            .font(.system(size: 50))
                    }
                }
                .foregroundColor(isBadge ? Color.orange : Color.gray)
            }
        }
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

struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
        AwardView()
    }
}
