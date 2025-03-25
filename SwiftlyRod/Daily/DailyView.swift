//
//  DailyView.swift
//  SwiftlyRod
//
//  Created by Roderick Lizardo on 3/20/25.
//
import Foundation
import SwiftUI
import RiveRuntime
import HealthKit


struct hkActivity {
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
}


extension HKWorkoutActivityType {
    
    var name: String {
        switch self {
        case .running: return "Running"
        case .cycling: return "Cycling"
        case .walking: return "Walking"
        case .yoga: return "Yoga"
        case .traditionalStrengthTraining: return "Strength Training"
        case .soccer: return "Soccer"
        case .basketball: return "Basketball"
        case .stairClimbing: return "Stairstepper"
        case .kickboxing: return "Kickboxing"
        default: return "Other"
        }
    }
    
    var image: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .walking: return "figure.walk"
        case .yoga: return "figure.cooldown"
        case .traditionalStrengthTraining: return "dumbbell"
        case .soccer: return "figure.soccer"
        case .basketball: return "figure.basketball"
        case .stairClimbing: return "figure.stairs"
        case .kickboxing: return "figure.kickboxing"
        default: return "figure.mixed.cardio"
        }
    }
    
    var color: Color {
        switch self {
        case .running: return .green
        case .cycling: return .orange
        case .walking: return .blue
        case .yoga: return .purple
        case .traditionalStrengthTraining: return .blue
        case .soccer: return .indigo
        case .basketball: return .orange
        case .stairClimbing: return .mint
        case .kickboxing: return .red
        default: return .gray
        }
    }
}


struct DailyRingView: View {
    @State private var sectionRadius: CGFloat = 15.0
    @StateObject var homeViewModel = HomeViewModel()

    
    @StateObject var healthRing = RiveViewModel(fileName: "radial_bar_animation", stateMachineName: "State Machine 1")
    
    @State private var calories: Int = 0
    @State private var caloriesGoals: Int = 0
    
    @State private var exercise: Int = 0
    @State private var exerciseGoals: Int = 0
    
    @State private var stand: Int = 0
    @State private var standGoals: Int = 0
    @State private var count: Int = 0

    @State private var stepGoal: Int = 0
    @State private var stepCount: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            let barHeight = geometry.size.height * 0.8
            let progressRatio = min(Double(stepCount) / Double(stepGoal), 1.0)
            ZStack {
//                VStack {
//                    Text("Daily Summary")
//                        .font(Font.custom("SF Pro", size: 18))
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Divider()
//                        .frame(height: 0.3)
//                        .background(Color.white)
//                        .offset(y: -15)
//
//                }
//                Spacer()
                DailyActivityView()
                
                HStack(spacing:20) {
                    ZStack(alignment: .bottom) {
                        // Goal background bar
                        Rectangle()
                            .frame(width: 30, height: barHeight)
                            .foregroundColor(.gray.opacity(0.2))
                            .cornerRadius(5)
                        
                        Rectangle()
                            .frame(width: 30, height: barHeight * progressRatio)
                            .foregroundColor(.green)
                            .cornerRadius(5)
                            .animation(.easeInOut(duration: 0.4), value: progressRatio)
                    }
//                    VStack {
//                        Rectangle()
//                            .frame(width: 30, height:geometry.size.height * 0.8)
//                            .foregroundColor(.green)
//                            .cornerRadius(5.0)
//                    }
//                    
//                    Rectangle()
//                        .frame(width: 30, height:geometry.size.height * 0.8)
//                        .foregroundColor(.blue)
//                        .cornerRadius(5.0)
                }
                .offset(x:-135)
                
                showActivityRings()
                    .offset(x:50)
                    .padding()
            

            
            }
            .onChange(of: homeViewModel.homeViewActivity.count) {
//                print("Testing: \(homeViewModel.homeViewActivity.prefix(homeViewModel.showAllActivities == true ? 1 : 1))")
                for activity in homeViewModel.homeViewActivity {
                    if activity.title == "Today Steps" {
                        let subtitle = activity.subtitle
                        stepGoal = Int(subtitle.replacingOccurrences(of: "Goal: ", with: ""))!
                        stepCount = Int(activity.amount.replacingOccurrences(of: ",", with: ""))!
//                        print("steps","\(stepCount)","\(stepGoal)", type(of: stepCount), type(of: stepGoal))
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
    }
    
    func showActivityCounter() -> some View {
        return ZStack {
            VStack {
                Text("Total Activities of this Month")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(15)
    }
    
    func showActivityRings() -> some View {
        return ZStack {
//            DailyActivityView()
//                .frame(width: 200, height: 200)
//                .offset(x:-250)
//                .scaleEffect(0.6)
            
            
            healthRing.view()
                .onAppear {
                    healthRing.setInput("calories", value: CGFloat(homeViewModel.calories))
                }
                .onChange(of: homeViewModel.calories) {
                    
                    calories = homeViewModel.calories
                    caloriesGoals = homeViewModel.caloriesGoal
                    let caloriesProgress: CGFloat = CGFloat(CGFloat(calories) / CGFloat(caloriesGoals) * 100)
                    print("Calories: \(caloriesProgress)")
                    healthRing.setInput("calories", value: caloriesProgress)
                }
                .onChange(of: homeViewModel.exercise) {
                    exercise = homeViewModel.exercise
                    exerciseGoals = homeViewModel.activeGoal
                    
                    let exerciseProgress: CGFloat = CGFloat(CGFloat(exercise) / CGFloat(exerciseGoals) * 100)
                    
                    print("Exercise: \(exerciseProgress)")
                    healthRing.setInput("exercise", value: exerciseProgress)
                }
                .onChange(of: homeViewModel.stand) {
                    stand = homeViewModel.stand
                    standGoals = homeViewModel.standGoal
                    
                    let standProgress: CGFloat = CGFloat(CGFloat(stand) / CGFloat(standGoals) * 100)
                    
                    print("Stand: \(standProgress)")
                    healthRing.setInput("stand", value: standProgress)
                }
            
            HStack {
                VStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(Color(hex: "FF5722"))
                    Text("\(calories)/\(caloriesGoals)")
                        .font(Font.custom("SF Pro", size: 12))
                        .foregroundColor(Color(hex: "FF5722"))
                    
                    
                    Rectangle()
                        .frame(height: 0.02)
                        .opacity(0.0)
                    

                    Image(systemName: "figure.walk")
                        .foregroundColor(Color(hex: "FFC300"))
                    Text("\(exercise)/\(exerciseGoals)")
                        .font(Font.custom("SF Pro", size: 12))
                        .foregroundColor(Color(hex: "FFC300"))
                    
                    Rectangle()
                        .frame(height: 0.02)
                        .opacity(0.0)
                    
                    Image(systemName: "chevron.up.2")
                        .foregroundColor(Color(hex: "00D9FF"))
                    Text("\(stand)/\(standGoals)")
                        .font(Font.custom("SF Pro", size: 12))
                        .foregroundColor(Color(hex: "00D9FF"))
                
                }
            }
        }
    }
}

struct StravaStepDistanceView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(.gray.opacity(0.15))
            VStack(alignment: .leading, spacing: 5) {
                Text("Step Distance")
                    .font(Font.custom("SF Pro", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                Divider()
                    .frame(height: 0.4)
                    .background(Color.gray)
//                    .offset(y: -15)
            }
            .offset(y:10)
        }
    }
}



struct CaloriesBurnedCardView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
        }
    }
}

struct StepsCardView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
        }
    }
}

struct ProgressCircleView: View {
    var progress: Int
    var goal: Int
    var color: Color
    private let width: CGFloat = 20

    
    var body: some View {
        ZStack {
//            let caloriesBurned: CGFloat = CGFloat(progress) / CGFloat(goal)
            Circle()
                .stroke(color.opacity(0.3), lineWidth: width)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress) / CGFloat(goal))
                .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 10)
                .onAppear() {
                    print(goal)
                }
        }
    }
}



@Observable
final class HomeViewModel: ObservableObject {
    
    var showPaywall = false
    var showAllActivities = false
    
    var calories: Int = 0
    var exercise: Int = 0
    var stand: Int = 0
    
    var stepGoal: Int = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
    var caloriesGoal: Int = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
    var activeGoal: Int = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
    var standGoal: Int = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    
    var homeViewActivity = [ActivityItems]()
    var workouts = [Workout]()
    
    var showAlert = false

    var healthManager: HealthManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        self.healthManager = healthManager
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                try await fetchHealthData()
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    @MainActor
    func fetchHealthData() async throws {
        // Fetch all health data in parallel at init of View Model
        async let fetchCalories: () = try await fetchTodayCalories()
        async let fetchExercise: () = try await fetchTodayExerciseTime()
        async let fetchStand: () = try await fetchTodayStandHours()
        async let fetchSteps: () = try await fetchTodaySteps()
        async let fetchActivities: () = try await fetchCurrentWeekActivities()
        async let fetchWorkouts: () = try await fetchRecentWorkouts()
        
        let (_, _, _, _, _, _) = (try await fetchCalories, try await fetchExercise, try await fetchStand, try await fetchSteps, try await fetchActivities, try await fetchWorkouts)
    }
    
    func fetchGoalData() {
        stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
        caloriesGoal = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
        activeGoal = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
        standGoal = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    }
    
    /// Fetches today calories and leaves the activity card blank if it fails
    func fetchTodayCalories() async throws {
        do {
            calories = Int(try await healthManager.fetchTodayCalories())
            let activity = ActivityItems(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "\(calories)")
            homeViewActivity.append(activity)
        } catch {
            let activity = ActivityItems(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "---")
            homeViewActivity.append(activity)
        }
    }
    
    func fetchTodayExerciseTime() async throws {
        exercise = Int(try await healthManager.fetchTodayExerciseTime())
    }
    
    func fetchTodayStandHours() async throws {
        stand = try await healthManager.fetchTodayStandHours()
    }
    
    // MARK: Fitness Activity
    
    /// Fetches today's steps and displays an empty card if it fails
    func fetchTodaySteps() async throws {
        let activity = try await healthManager.fetchTodaySteps()
        homeViewActivity.insert(activity, at: 0)
    }
    
    func fetchCurrentWeekActivities() async throws {
        let weekActivities = try await healthManager.fetchCurrentWeekActivities()
        homeViewActivity.append(contentsOf: weekActivities)
    }
    
    // MARK: Recent Workouts
    func fetchRecentWorkouts() async throws {
        let monthWorkouts = try await healthManager.fetchRecentWorkouts()
        // Only displays the most recent 4 (four) workouts, the rest are behind a paywall
        workouts = Array(monthWorkouts.prefix(4))
    }
        
}


struct Workout: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let tintColor: Color
    let duration: String
    let date: Date
    let calories: String
}

struct ActivityItems {
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
}

import Foundation
import HealthKit
protocol HealthManagerType {
    func requestHealthKitAccess() async throws
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void)
    func fetchTodayCalories() async throws -> Double
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void)
    func fetchTodayExerciseTime() async throws -> Double
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void)
    func fetchTodayStandHours() async throws -> Int
    func fetchTodaySteps(completion: @escaping(Result<ActivityItems, Error>) -> Void)
    func fetchTodaySteps() async throws -> ActivityItems
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[ActivityItems], Error>) -> Void)
    func fetchCurrentWeekActivities() async throws -> [ActivityItems]
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void)
    func fetchRecentWorkouts() async throws -> [Workout]
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void)
    func fetchOneWeekStepData() async throws -> [DailyStepModel]
    func fetchOneMonthStepData() async throws -> [DailyStepModel]
    func fetchThreeMonthsStepData() async throws -> [DailyStepModel]
    func fetchYTDAndOneYearChartData() async throws -> YearChartDataResult
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void)
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void)
}

final class HealthManager: HealthManagerType {
    
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    
    @MainActor
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    /// Fetches the total calories burned today.
    ///
    /// Uses HealthKit to fetch the total number of calories burned from the start of the day until now.
    ///
    /// - Parameter completion: A completion handler that returns either the total calories burned as `Double` or an error.
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayCaloriesBurned { result in
                switch result {
                case .success(let calories):
                    continuation.resume(returning: calories)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// Fetches the total exercise time for the current day.
    ///
    /// This function queries HealthKit for the sum of apple exercise time from the start of the current day until now.
    /// - Parameter completion: A completion handler that returns a result containing either the total exercise time in minutes as `Double` or an error.
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayExerciseTime { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Fetches the number of stand hours for the current day.
    ///
    /// This function queries HealthKit for the count of apple stand hours from the start of the current day until now.
    /// - Parameter completion: A completion handler that returns a result containing either the number of stand hours as `Int` or an error.
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(error!))
                return
            }
            
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours() async throws -> Int {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayStandHours { result in
                continuation.resume(with: result)
            }
        })
    }
    
    // MARK: Fitness Activity
    
    /// Fetches the number of steps for the current day.
    ///
    /// This function queries HealthKit for the sum of steps taken from the start of the current day until now, comparing it against the user's step goal.
    /// - Parameter completion: A completion handler that returns a result containing an `Activity` object with today's step count or an error.
    func fetchTodaySteps(completion: @escaping(Result<ActivityItems, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.success(ActivityItems(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: "---")))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let stepsGoal = UserDefaults.standard.value(forKey: "stepsGoal") ?? 7500
            let activity = ActivityItems(title: "Today Steps", subtitle: "Goal: \(stepsGoal)", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaySteps() async throws -> ActivityItems {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodaySteps { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Fetches the current week's workout statistics.
    ///
    /// This function queries HealthKit for workout samples from the start of the current week until now and categorizes them by type to calculate the total duration of each workout type.
    /// - Parameter completion: A completion handler that returns a result containing a list of `Activity` objects representing the week's workout statistics or an error.
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[ActivityItems], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Only tracking acitivties we are interested in
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(self.generateActivitiesFromDurations(running: runningCount, strength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        
        healthStore.execute(query)
    }
    
    /// Generates `Activity` objects from workout durations.
    ///
    /// This helper function creates `Activity` objects for various types of workouts based on their durations.
    private func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [ActivityItems] {
        return [
            ActivityItems(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            ActivityItems(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .blue, amount: "\(strength) mins"),
            ActivityItems(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) mins"),
            ActivityItems(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
            ActivityItems(title: "Stairstepper", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(stairs) mins"),
            ActivityItems(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxing) mins"),
        ]
    }
    
    func fetchCurrentWeekActivities() async throws -> [ActivityItems] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchCurrentWeekWorkoutStats { result in
                continuation.resume(with: result)
            }
        })
    }
    
    // MARK: Recent Workouts
    
    /// Fetches workout data for a specified month.
    ///
    /// Queries HealthKit for workouts within the specified month, sorting them by their start date. This method is useful for generating workout cards displayed on the app's home screen.
    ///
    /// - Parameters:
    ///   - month: The month for which to fetch workout data, represented as a `Date`.
    ///   - completion: A completion handler that returns a result containing either an array of `Workout` objects for the specified month or an error.
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Generates workout cards that will be displayed on home screen
            let workoutsArray = workouts.map( { Workout(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate, calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + " kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
    func fetchRecentWorkouts() async throws -> [Workout] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchWorkoutsForMonth(month: .now) { result in
                continuation.resume(with: result)
            }
        })
    }
    
}
    // MARK: ChartsView Data
extension HealthManager {
    
    /// Fetches daily step count starting from a specified date.
    ///
    /// Initiates a query to HealthKit for the daily number of steps, aggregating data by day from the start date to the current date. This method supports rendering step count trends over time.
    ///
    /// - Parameters:
    ///   - startDate: The start date from which to begin aggregating step data.
    ///   - completion: A completion handler that returns a result containing an array of `DailyStepModel` instances representing the daily step counts or an error.
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        // Method to query health data for each date of a given period
        query.initialResultsHandler = { _, results, error in
            guard let result = results, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var dailySteps = [DailyStepModel]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepModel(date: statistics.startDate, count: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            completion(.success(dailySteps))
        }
        healthStore.execute(query)
    }
    
    func fetchOneWeekStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .oneWeekAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    func fetchOneMonthStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .oneMonthAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }

    func fetchThreeMonthsStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .threeMonthsAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// Fetches step count data for the current year-to-date (YTD) and the past one year.
    ///
    /// This method executes multiple queries to HealthKit to compile step count data by month for the previous year and the current year to date. It's designed to provide a comprehensive view of the user's step activity over these periods.
    ///
    /// - Parameter completion: A completion handler that returns a result containing `YearChartDataResult` which includes arrays of `MonthlyStepModel` for both the YTD and one-year periods or an error.
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void) {
        
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonths = [MonthlyStepModel]()
        var ytdMonths = [MonthlyStepModel]()
        // Note: Query is imbedded in a for loop to fetch data for previous 12 months
        // Approach could be improved as running into an error for a given month will return failure/error for the entire call
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error, error.localizedDescription != "No data available for the specified predicate." {
                    completion(.failure(error))
                }
                
                let steps = results?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                
                if i == 0 {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                } else {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    }
                }
                
                // On last interation of the loop (last month), call completion success
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonths, oneYear: oneYearMonths)))
                }
            }
            healthStore.execute(query)
        }
    }
    
    func fetchYTDAndOneYearChartData() async throws -> YearChartDataResult {
        try await requestHealthKitAccess()
        return try await withCheckedThrowingContinuation({ continuation in
            fetchYTDAndOneYearChartData { result in
                switch result {
                case .success(let res):
                    continuation.resume(returning: res)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
}

   // MARK: Leaderboard View
extension HealthManager {

    /// Fetches the total step count for the current week.
    ///
    /// Queries HealthKit for the sum of steps taken from the start of the current week to the present. This data is used to populate the leaderboard, comparing the user's activity against others.
    ///
    /// - Parameter completion: A completion handler that returns a result containing the total step count as a `Double` or an error.
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())

        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        
        healthStore.execute(query)
    }
    
}

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct YearChartDataResult {
    let ytd: [MonthlyStepModel]
    let oneYear: [MonthlyStepModel]
}

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}



extension Date {

    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }

    // Treats Monday as start of week
    static var startOfWeek: Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Monday
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        components.weekday = 2

        // Calculate the start of the week date
        var startOfWeek = calendar.date(from: components) ?? Date()

        // Check if today is Sunday (weekday == 1) and adjust the startOfWeek to the previous Monday
        if weekday == 1 {
            let adjustedDate = calendar.date(byAdding: .day, value: -7, to: startOfWeek)
            startOfWeek = adjustedDate ?? startOfWeek
        }

        return startOfWeek
    }
    
    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var threeMonthsAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    // Returns start date and end date of given month
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        let calendar = Calendar.current
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    func mondayDateFormat() -> String {
        let monday = Date.startOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
    
    func monthAndYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: self)
    }
    
    func timeOfDayGreeting() -> String {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: self)
            
            switch hour {
            case 2..<12:
                return "Good Morning,"
            case 12..<18:
                return "Good Afternoon,"
            default:
                return "Good Evening,"
            }
        }
}


extension Double {
    
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}


//#Preview {
//    YouView()
//}
