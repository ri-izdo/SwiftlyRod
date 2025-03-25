//
//  MonthWorkoutGraph.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//


import Foundation
import SwiftUI
import Charts

struct MonthWorkoutsGraph: View {
//    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var chartsViewModel = ChartsViewModel()
    @State private var date = Date()
    @State private var formatter = DateFormatter()
    @State private var currentMonth: String = ""
    @State private var activityCount: Int = 0
    

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("\(currentMonth) Activities | Total \(chartsViewModel.oneMonthTotal)")
                        .font(Font.custom("SF Pro", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear {
                            formatter.dateFormat = "MMMM" // "MMMM" gives full month name like "March"
                            currentMonth = formatter.string(from: date)
                            
                        }
                    
                    Divider()
                        .frame(height: 0.3)
                        .background(Color.white)
                        .offset(y: -15)
                }
                Spacer()
                HStack {
//                    VStack {
//                        ChartDataView(average: $chartsViewModel.oneMonthAverage, total: $chartsViewModel.oneMonthTotal)
                        
                    Chart {
                        ForEach(chartsViewModel.oneMonthChartData) { data in
                            BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
//                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
}
//
//#Preview {
//    YouView()
//}
