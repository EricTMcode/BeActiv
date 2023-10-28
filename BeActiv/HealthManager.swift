//
//  HealthManager.swift
//  BeActiv
//
//  Created by Eric on 26/10/2023.
//

import Foundation
import HealthKit


extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static var startOfWeek: Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Monday
        
        return calendar.date(from: components)!
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activites: [String : Activity] = [:]
    @Published var mockActivities: [String : Activity] = [
        "todaySteps" : Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "12,1234"),
        "todayCalories" : Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: "1,241"),
        "weekRunning" : Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.walk", tintColor: .green, amount: "60 minutes"),
        "weekStrength" : Activity(id: 3, title: "Weight Lifting", subtitle: "This week" , image: "dumbbell", tintColor: .cyan, amount: "80 minutes"),
        "weekSoccer" : Activity(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount: "20 minutes"),
        "weekBasketball" : Activity(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount: "18 minutes"),
        "weekStairs" : Activity(id: 6, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .green, amount: "10 minutes"),
        "weekKickbox" : Activity(id: 7, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "25 minutes")
        
    ]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories, workout]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWorkoutStats()
            } catch {
                print("Error fetching health data")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching todays step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activites["todaySteps"] = activity
            }
            
            print(stepCount.formattedString())
          
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching todays calorie data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activites["todayCalories"] = activity
            }
            
            print(caloriesBurned.formattedString())
        }
        healthStore.execute(query)
    }
    
//    func fetchWeekRunningStats() {
//        let workout = HKSampleType.workoutType()
//        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
//        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
//        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
//            guard let workouts = sample as? [HKWorkout], error == nil else {
//                print("Error fetching week running data")
//                return
//            }
//            
//            var count: Int = 0
//            for workout in workouts {
//                let duration = Int(workout.duration)/60
//                count += duration
//            }
//            let activity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.walk", amount: "\(count) minutes")
//            
//            DispatchQueue.main.async {
//                self.activites["weekRunning"] = activity
//            }
//        }
//        healthStore.execute(query)
//    }
    
//    func fetchCurrentWeekStrengthStats() {
//        let workout = HKSampleType.workoutType()
//        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
//        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
//        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
//            guard let workouts = sample as? [HKWorkout], error == nil else {
//                print("Error fetching week running data")
//                return
//            }
//            
//            var count: Int = 0
//            for workout in workouts {
//                let duration = Int(workout.duration)/60
//                count += duration
//            }
//            let activity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", amount: "\(count) minutes")
//            
//            DispatchQueue.main.async {
//                self.activites["weekStrength"] = activity
//            }
//        }
//        healthStore.execute(query)
//        
//    }
    
    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching week running data")
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration)/60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration)/60
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration)/60
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    let duration = Int(workout.duration)/60
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    let duration = Int(workout.duration)/60
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    let duration = Int(workout.duration)/60
                    kickboxingCount += duration
                }
            }
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week" , image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) minutes")
            let soccerActivity = Activity(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount: "\(soccerCount) minutes")
            let basketballActivity = Activity(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount: "\(basketballCount) minutes")
            let stairActivity = Activity(id: 6, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .green, amount: "\(stairsCount) minutes")
            let kickboxingActivity = Activity(id: 7, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(basketballCount) minutes")
            
            DispatchQueue.main.async {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStrength"] = strengthActivity
                self.activites["weekSoccer"] = soccerActivity
                self.activites["weekBasketball"] = basketballActivity
                self.activites["weekStairs"] = stairActivity
                self.activites["weekKickbox"] = kickboxingActivity
            }
        }
        healthStore.execute(query)
        
    }
    
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
