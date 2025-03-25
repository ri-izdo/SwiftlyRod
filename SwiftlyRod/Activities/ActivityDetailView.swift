//
//  ActivityDetailView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/12/25.
//
//
//import SwiftUI
//import StravaSwift
//
//
//extension Activity: Identifiable, Hashable {
//    public var id: Int {
//        return hashValue // Using hashValue directly from Hashable conformance
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(name) // Use unique properties to generate hash
//        hasher.combine(startDate)
//    }
//
//    public static func == (lhs: Activity, rhs: Activity) -> Bool {
//        return lhs.name == rhs.name && lhs.startDate == rhs.startDate
//    }
//}
//
//
//struct ActivityDetailView: View {
//    let activity: Activity
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                Text(activity.name ?? "Unnamed Activity")
//                    .font(.largeTitle)
//                    .bold()
//
//                if let date = activity.startDate {
//                    Text("📅 Date: \(date, style: .date)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//
//                if let description = activity.description {
//                    Text("📝 Description: \(description)")
//                        .font(.body)
//                }
//
//                if let distance = activity.distance {
//                    Text("📏 Distance: \(String(format: "%.2f", distance / 1000)) km")
//                        .font(.body)
//                }
//
//                if let elapsedTime = activity.elapsedTime {
//                    Text("⏳ Duration: \(formatTime(seconds: elapsedTime))")
//                        .font(.body)
//                }
//
//                if let averageSpeed = activity.averageSpeed {
//                    Text("🚴‍♂️ Avg Speed: \(String(format: "%.2f", averageSpeed * 3.6)) km/h")
//                        .font(.body)
//                }
//
//                if let maxSpeed = activity.maxSpeed {
//                    Text("⚡ Max Speed: \(String(format: "%.2f", maxSpeed * 3.6)) km/h")
//                        .font(.body)
//                }
//
//                if let totalElevationGain = activity.totalElevationGain {
//                    Text("🏔 Elevation Gain: \(String(format: "%.2f", totalElevationGain)) m")
//                        .font(.body)
//                }
//
//                if let calories = activity.calories {
//                    Text("🔥 Calories Burned: \(String(format: "%.0f", calories)) kcal")
//                        .font(.body)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Activity Details")
//    }
//
//    /// Formats time in HH:MM:SS
//    func formatTime(seconds: TimeInterval) -> String {
//        let hours = Int(seconds) / 3600
//        let minutes = (Int(seconds) % 3600) / 60
//        let seconds = Int(seconds) % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//}
