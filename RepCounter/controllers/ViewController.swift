//
//  ViewController.swift
//  RepCounter
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let record = PersistenceManager.sharedInstance.fetchBestWorkout()?.repsCompleted ?? 0
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            recordButton.setTitle(NSLocalizedString("Rep Record: \(record)", comment: ""), for: state)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let record = PersistenceManager.sharedInstance.fetchBestWorkout()?.repsCompleted ?? 0
        
        let activityViewController = UIActivityViewController(activityItems: ["My rep record is \(record)"], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }

}
