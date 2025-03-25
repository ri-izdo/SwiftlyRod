//
//  MonthsWorkoutViewModel.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/24/25.
//

import Foundation
import SwiftUI

@Observable
final class MonthWorkoutsViewModel: ObservableObject {
    
    var selectedMonth = 0
    var selectedDate = Date()
    var fetchedMonths: Set<String> = []
    
    var workouts = [Workout]()
    var currentMonthWorkouts = [Workout]()
    
    var showAlert = false
    
    let healthManager = HealthManager.shared
    
    init() {
        Task {
            do {
                try await fetchWorkoutsForMonth()
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
        
        if fetchedMonths.contains(selectedDate.monthAndYearFormat()) {
            self.currentMonthWorkouts = workouts.filter( { $0.date.monthAndYearFormat() == selectedDate.monthAndYearFormat() } )
        } else {
            Task {
                do {
                    try await fetchWorkoutsForMonth()
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func fetchWorkoutsForMonth() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchWorkoutsForMonth(month: selectedDate) { result in
                switch result {
                case .success(let workouts):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.workouts.append(contentsOf: workouts)
                        self.fetchedMonths.insert(self.selectedDate.monthAndYearFormat())
                        self.currentMonthWorkouts = self.workouts.filter( { $0.date.monthAndYearFormat() == self.selectedDate.monthAndYearFormat() } )
                        continuation.resume()
                    }
                case .failure(_):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                        continuation.resume()
                    }
                }
            }
        }) as Void
    }
    
}


