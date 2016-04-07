//
//  ThumbnailCell.swift
//  FactsOfToday
//
//  Created by Evan on 4/4/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import AFNetworking

class ThumbnailCell: UICollectionViewCell {
	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
    var url: NSURL?
    
	var title: String! {
		didSet {
			titleLabel.text = title
		}
	}
	
	var imageUrl: NSURL? {
		didSet {
			if imageUrl != nil {
				thumbnailImageView.setImageWithURL(imageUrl!)
			} else {
				thumbnailImageView.image = UIImage(named: "Wikipedia_Logo")
			}
		}
	}
	
	override func awakeFromNib() {
		if imageUrl == nil {
			thumbnailImageView.image = UIImage(named: "Wikipedia_Logo")
		}
		
		let background = UIView()
		self.backgroundView = background
		self.backgroundView?.backgroundColor = UIColor.clearColor()
		
		let selectedBackground = UIView()
		self.selectedBackgroundView = selectedBackground
		self.selectedBackgroundView?.backgroundColor = UIColor(red: 0.882, green: 0.882, blue: 0.882, alpha: 1)
	}
}
