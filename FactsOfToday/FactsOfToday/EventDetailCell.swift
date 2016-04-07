//
//  EventDetailCell.swift
//  FactsOfToday
//
//  Created by Darrell Shi on 3/8/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class EventDetailCell: UITableViewCell {
    @IBOutlet weak var detailLabel: TTTAttributedLabel!
	@IBOutlet weak var linkCollectionView: UICollectionView!
	
    var delegate: WebViewDelegate?
	var linkTitles: [String]?
	var thumbnailUrls: [NSURL?]?
	
	var dataTask: NSURLSessionDataTask?
    
    var event: Event! {
        didSet{
            let text = NSString(string: event.text!)
            detailLabel.text = text as String
            
            if let links = event.links {
				var urlArray = [NSURL?]()
				var titleArray = [String]()
				for link in links {
					if link.title != nil {
						titleArray.append(link.title!)
					}
					urlArray.append(link.url)
				}
				
				linkTitles = WikipediaClient.getArticleTitlesWithUrls(urlArray)
				linkCollectionView.reloadData()
				
				dataTask = WikipediaClient.getThumbnailForArticlesWithTitle(
						titleArray,
						urlTitles: linkTitles!,
						completion: {
					(imageUrls) in
						self.thumbnailUrls = imageUrls
						self.linkCollectionView.reloadData()
				})
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.delegate = self
		linkCollectionView.scrollsToTop = false
		linkCollectionView.delegate = self
		linkCollectionView.dataSource = self
		linkCollectionView.reloadData()
    }
	
	func setValues(event: Event?, delegate: WebViewDelegate) {
		linkTitles = nil
		thumbnailUrls = nil
		dataTask?.cancel()
		self.delegate = delegate
		self.event = event
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EventDetailCell: TTTAttributedLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        delegate?.openURL(url)
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if linkTitles != nil {
			return linkTitles!.count
		}
		
		return 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("thumbnailCell", forIndexPath: indexPath) as! ThumbnailCell

		cell.title = event.links![indexPath.row].title
		cell.imageUrl = thumbnailUrls?[indexPath.row]
		cell.url = event.links![indexPath.row].url
        
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)	{
		collectionView.deselectItemAtIndexPath(indexPath, animated: false)
		
//		delegate?.openURL(event.links![indexPath.row].url!)
	}
}
