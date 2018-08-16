//
//  PersistenceManager.swift
//  RepCounter
//

import Foundation

class PersistenceManager {

    static let sharedInstance = PersistenceManager()
    let workoutsKey = "workouts"

    func fetchBestWorkout() -> Workout? {
        let workouts = fetchWorkouts()
        let sortedWorkouts = workouts.sorted { $0.repsCompleted > $1.repsCompleted}
        return sortedWorkouts.first
    }

    func fetchWorkouts() -> [Workout] {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()

        // UserDefaults is on device storage, key-value storage
        // CoreData is better for on device storage, smarter
        let workoutsData = userDefaults.data(forKey: workoutsKey)

        if let workoutsData = workoutsData, let workouts = try? decoder.decode([Workout].self, from: workoutsData) {
            return workouts
        } else {
            // [Workout]() is an initialized empty array of Workouts
            return [Workout]()
        }
    }

    func fetchWorkoutsSorted() -> [Workout] {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()

        // UserDefaults is on device storage, key-value storage
        // CoreData is better for on device storage, smarter
        let workoutsData = userDefaults.data(forKey: workoutsKey)

        if let workoutsData = workoutsData, let workouts = try? decoder.decode([Workout].self, from: workoutsData) {
            return workouts.sorted(by: {$0.repsCompleted > $1.repsCompleted})
        } else {
            return [Workout]()
        }
    }

    func saveWorkout(_ workout: Workout) {
        let userDefaults = UserDefaults.standard
        var workouts = fetchWorkouts()
        workouts.append(workout)

        let encoder = JSONEncoder()
        let encodedWorkouts = try? encoder.encode(workouts)

        if let encodedWorkouts = encodedWorkouts {
            userDefaults.set(encodedWorkouts, forKey: workoutsKey)
        } else {
            print("Error: Could not encode workouts")
        }
    }

    func deleteWorkoutSorted(_ workout: Int) {
        let userDefaults = UserDefaults.standard
        var workouts = fetchWorkoutsSorted()
        workouts.remove(at: workout)

        let encoder = JSONEncoder()
        let encodedWorkouts = try? encoder.encode(workouts)

        if let encodedWorkouts = encodedWorkouts {
            userDefaults.set(encodedWorkouts, forKey: workoutsKey)
        } else {
            print("Error: Could not encode workouts")
        }
    }

}
