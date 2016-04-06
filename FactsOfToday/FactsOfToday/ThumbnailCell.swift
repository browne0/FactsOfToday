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
	}
}
