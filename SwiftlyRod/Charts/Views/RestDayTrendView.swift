//
//  RestDayTrendView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/26/25.
//

import Foundation
import SwiftUI
import StravaSwift
import Charts

struct restDayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let movingTime: Double
}

// Model for a single day
struct Day: Identifiable {
    let id = UUID()
    let date: Date
    let isCompleted: Bool
}

// View for each square
struct DaySquareView: View {
    var day: Day
    
    var body: some View {
        Rectangle()
            .frame(width: 30, height: 30)
            .foregroundColor(day.isCompleted ? Color(hex: "FF5722") : .gray)
            .overlay(
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .font(.caption2)
                    .foregroundColor(.white)
            )
    }
}

// Grid for the current month
struct MonthGridView: View {
    let days: [Day]
    
    // 7 columns for 7 days of the week
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(days) { day in
                DaySquareView(day: day)
            }
        }
        .padding()
    }
}


struct RestDayTrendView: View {
    var token: OAuthToken?
    
    @State private var thisMonthData: [restDayChartData] = []
    @State private var thisMonthActivities: [restDayChartData] = []
    @StateObject private var stravaViewModel = StravaActivitiesViewModel()
    
    @State private var lastFour: String = ""
    @State private var formattedDate: String = ""
    @State private var monthName: String = ""
    
    let calendar = Calendar.current
    let today = Date()
    
    var body: some View {
        let days = generateDaysForCurrentMonth()
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("Restday vs. Workday")
                            .font(.title.bold())
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }

            }
            .background(Color.gray.opacity(0.1))
            .onChange(of: stravaViewModel.activities) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM"
                monthName = formatter.string(from: today)
                
                formatter.dateFormat = "MM/dd"
                
                for activity in stravaViewModel.activities {
                    lastFour = String(activity.name?.suffix(4) ?? "")
                    
                    guard let startDate = activity.startDate else { continue }
                    let formattedDate = formatter.string(from: startDate)

                    let movingTime = activity.movingTime ?? 0.0
                    
                    print("RestDays chart: \(formattedDate) | moving time: \(movingTime)")
                    
                    thisMonthActivities.append(restDayChartData(date: startDate, movingTime: movingTime))
                    

                }
            }
            ZStack {
                VStack {
                    HStack {
                        MonthGridView(days: days)
                            .scaleEffect(0.5)
                            .padding()
                    }
                }
                
                HStack {
                    Text("ActiveDay")
                        .font(Font.custom("SF Pro", size: 14))
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Rectangle()
                        .frame(width: 20, height: 10)
                        .foregroundColor(Color(hex: "FF5722"))

                }
                .offset(x:40 ,y:65)
            }
        }
    }
    
    func generateDaysForCurrentMonth() -> [Day] {
        var days: [Day] = []
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let components = calendar.dateComponents([.year, .month], from: today)
        let startOfMonth = calendar.date(from: components)!
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let isCompleted = Bool.random() // Replace with your real logic
                days.append(Day(date: date, isCompleted: isCompleted))
            }
        }
        return days
    }
}
