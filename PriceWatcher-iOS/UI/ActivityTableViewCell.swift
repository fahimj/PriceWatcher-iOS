//
//  ActivityTableViewCell.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(data:DisplayedPriceRequest) {
        timeLabel.text = "Time: " + data.time.ISO8601Format()
        priceLabel.text = "Price: \(data.value)"
        longitudeLabel.text = "Longitude: \(data.longitude)"
        latitudeLabel.text = "Latitude: \(data.latitude)"
    }
    
}
