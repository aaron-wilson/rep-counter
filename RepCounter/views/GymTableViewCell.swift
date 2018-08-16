//
//  GymTableViewCell.swift
//  RepCounter
//

import UIKit

class GymTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gymNameLabel: UILabel!
    
    @IBOutlet weak var gymAddressLabel: UILabel!
    
    @IBOutlet weak var gymImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
