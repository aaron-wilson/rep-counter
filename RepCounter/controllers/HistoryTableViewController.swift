//
//  HistoryTableViewController.swift
//  RepCounter
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var workouts = [Workout]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM d, h:mm a"
        workouts = PersistenceManager.sharedInstance.fetchWorkoutsSorted()
    }

    // Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        // Configure cell
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = "\(workout.name) - \(workout.repsCompleted)"

        cell.detailTextLabel?.text = dateFormatter.string(from: workout.date)
        cell.detailTextLabel?.textColor = .gray

        return cell
    }

    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove the item from the data model
            workouts.remove(at: indexPath.row)
            PersistenceManager.sharedInstance.deleteWorkoutSorted(indexPath.row)

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Add row
            return
        }
    }

}
