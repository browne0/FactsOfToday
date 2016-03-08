//
//  EventDetailCell.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    var event: Event! {
        didSet{
            detailLabel.text = event.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
