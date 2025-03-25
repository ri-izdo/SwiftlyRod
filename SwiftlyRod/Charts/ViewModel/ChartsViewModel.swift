//
//  ChartsViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/9/23.
//

import Foundation


@Observable
final class ChartsViewModel: ObservableObject {
    
    var selectedChart: ChartOptions = .oneWeek
    
    var oneWeekChartData = [DailyStepModel]()
    var oneWeekAverage = 0
    var oneWeekTotal = 0
    
    var oneMonthChartData = [DailyStepModel]()
    var oneMonthAverage = 0
    var oneMonthTotal = 0
    
    var threeMonthsChartData = [DailyStepModel]()
    var threeMonthAverage = 0
    var threeMonthTotal = 0
    
    var ytdChartData = [MonthlyStepModel]()
    var ytdAverage = 0
    var ytdTotal = 0
    
    var oneYearChartData = [MonthlyStepModel]()
    var oneYearAverage = 0
    var oneYearTotal = 0
    
    var showAlert = false
    
    var healthManager: HealthManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        self.healthManager = healthManager
        Task {
            do {
                // Batch fetches all the health & chart data
                async let oneWeek: () = try await fetchOneWeekStepData()
                async let oneMonth: () = try await fetchOneMonthStepData()
                async let threeMonths: () = try await fetchThreeMonthsStepData()
                async let ytdAndOneYear: () = try await fetchYTDAndOneYearChartData()
                
                _ = (try await oneWeek, try await oneMonth, try await threeMonths, try await ytdAndOneYear)
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    func mockChartDataFor(days: Int) -> [DailyStepModel] {
        var mockData = [DailyStepModel]()
        for day in 0..<days {
            let currentDate = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            // Generating a random step count between 5000 and 15000
            let randomStepCount = Int.random(in: 500...15000)
            let dailyStepData = DailyStepModel(date: currentDate, count: randomStepCount)
            mockData.append(dailyStepData)
        }
        return mockData
    }
    
    func calculateAverageAndTotalFromData(steps: [DailyStepModel]) -> (Int, Int) {
        let total = steps.reduce(0, { $0 + $1.count })
        let average = total / steps.count
        
        return (total, average)
    }
    
    @MainActor
    func fetchOneWeekStepData() async throws {
        oneWeekChartData = try await healthManager.fetchOneWeekStepData()
        
        (oneWeekTotal, oneWeekAverage) = calculateAverageAndTotalFromData(steps: oneWeekChartData)
    }
    
    func fetchOneMonthStepData() async throws {
        oneMonthChartData = try await healthManager.fetchOneMonthStepData()
        
        (oneMonthTotal, oneMonthAverage) = calculateAverageAndTotalFromData(steps: oneMonthChartData)
    }
    
    func fetchThreeMonthsStepData() async throws {
        threeMonthsChartData = try await healthManager.fetchThreeMonthsStepData()
        
        (threeMonthTotal, threeMonthAverage) = calculateAverageAndTotalFromData(steps: threeMonthsChartData)
    }
        
    func fetchYTDAndOneYearChartData() async throws {
        let result = try await healthManager.fetchYTDAndOneYearChartData()
        ytdChartData = result.ytd
        oneYearChartData = result.oneYear
        
        ytdTotal = ytdChartData.reduce(0, { $0 + $1.count })
        oneYearTotal = oneYearChartData.reduce(0, { $0 + $1.count })
        
        ytdAverage = ytdTotal / Calendar.current.component(.month, from: Date.now)
        oneYearAverage = oneYearTotal / 12
    }
    
    /// Fetches both one year and year to date data in one pass
    
}
