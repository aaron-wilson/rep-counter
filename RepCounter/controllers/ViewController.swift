//
//  ViewController.swift
//  RepCounter
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let record = PersistenceManager.sharedInstance.fetchBestWorkout()?.repsCompleted ?? 0
        recordLabel.text = "Rep Record: \(record)"
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let record = PersistenceManager.sharedInstance.fetchBestWorkout()?.repsCompleted ?? 0
        
        let activityViewController = UIActivityViewController(activityItems: ["My rep record is \(record)"], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }

}
