//
//  RepCounterViewController.swift
//  RepCounter
//

import UIKit

class RepCounterViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    
    private var counter = 0 {
        didSet {
            counterLabel.text = String(counter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        // create alert
        let alertController = UIAlertController(title: "Save Workout", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Workout"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            let value = alertController.textFields![0]

            // ?? is the nil-coalescing operator, but "" != nil
            let name = (value.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty ?
                "Workout" : value.text

            let workout = Workout(name: name!, repsCompleted: self.counter, date: Date())
            PersistenceManager.sharedInstance.saveWorkout(workout)
            self.counter = 0
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    @IBAction func repButtonPressed(_ sender: Any) {
        counter += 1
    }

}

extension RepCounterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
