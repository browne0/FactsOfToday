//
//  WikipediaClient.swift
//  FactsOfToday
//
//  Created by Evan on 3/26/16.
//  Copyright © 2016 FactsOfToday. All rights reserved.
//

import Foundation
import MapKit

class WikipediaClient {
	
	/// Parse a URL for a Wikipedia article to get the title of the article (in the URL format)
	///
	/// - note: If the URL is nil or is not a link to a Wikipedia article, the return value will be nil
	///
	/// - returns: The portion of the URL that refers to the Wikipedia article's title.
	class func getArticleTitleUrl(wikiUrl: NSURL?) -> String? {
		if wikiUrl == nil {
			return nil
		}
		
		if let match = wikiUrl?.absoluteString.rangeOfString("^https:\\/\\/[a-zA-Z]{2}\\.(m\\.)?wikipedia\\.org\\/wiki\\/", options: .RegularExpressionSearch) {
			let urlPath = wikiUrl?.absoluteString.substringFromIndex(match.endIndex)
			if let articleTitleUrl = (urlPath?.componentsSeparatedByString("#"))?[0] {
				return articleTitleUrl
			} else {
				return nil
			}
		} else {
			return nil
		}
	}
	
	/// Parse an array of Wikipedia article URLs to return the URL format of that article's title
	///
	/// - note: The returned array of strings may not be the same size as the array of URLs that was passed to the function. Any URL that does not link to a Wikipedia article or is nil will not be added to the returned array.
	///
	/// - returns: An array of the titles that were successfully parsed from the given URLs
	class func getArticleTitlesWithUrls(wikiUrls: [NSURL?]) -> [String] {
		var titles = [String]()
		
		for url in wikiUrls {
			if let match = url?.absoluteString.rangeOfString("^https:\\/\\/[a-zA-Z]{2}\\.(m\\.)?wikipedia\\.org\\/wiki\\/", options: .RegularExpressionSearch) {
				let urlPath = url?.absoluteString.substringFromIndex(match.endIndex)
				if let articleTitleUrl = (urlPath?.componentsSeparatedByString("#"))?[0] {
					titles.append(articleTitleUrl)
				}
			}
		}
		
		return titles
	}
	
	/// Get the coordinates of a Wikipedia Article given the article title (in its URL format)
	///
	/// - note: If the article does not have any coordinates, the title does not refer to a Wikipedia article, or if any network errors occur, the coordinates returned in the completion block will be nil
	///
	/// - returns: A coordinate object with the location of the subject of the Wikipedia article.
	class func getCoordinatesForArticleWithTitle(title: String, completion: (coordinates: CLLocationCoordinate2D?) -> () ) {
		let url = NSURL(string: "https://en.wikipedia.org/w/api.php?action=query&prop=coordinates&format=json&titles=\(title)")
		if url == nil {
			print("error creating URL from string: \(title)")
			completion(coordinates: nil)
			return
		}
		
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate: nil,
			delegateQueue:  NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
			completionHandler: { (dataOrNil, response, error) in
			if error != nil {
				print("error getting coordinates for article:\n\(error?.localizedDescription)")
				completion(coordinates: nil)
				return
			}

			do {
				if let data = dataOrNil {
					if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
						if let pages = responseDictionary["query"]?["pages"] as? NSDictionary {
							let pageIds = pages.allKeys as? [String]
							
							if pageIds?.count > 0 {
								let page = pages[pageIds![0]]
								
								if page?.objectForKey("coordinates") != nil {
									let coordinatesDictionary = (page?.objectForKey("coordinates") as? [NSDictionary])![0]
									
									let coordinates = CLLocationCoordinate2D(
										latitude: CLLocationDegrees(coordinatesDictionary["lat"] as! Double),
										longitude: CLLocationDegrees(coordinatesDictionary["lon"] as! Double))
									
									completion(coordinates: coordinates)
									return
								}
							}
						}
					}
				}
			} catch let error as NSError {
				print("error parsing response, getting coordinates.\n\(error)")
			}

			completion(coordinates: nil)
		});
		task.resume()
	}
	
	
	/// Get the thumbnail image URL of a Wikipedia Article given the article title (in its URL format)
	///
	/// - note: If the article does not have a thumbnail, the title does not refer to a Wikipedia article, or if any network errors occur, the URL returned in the completion block will be nil
	///
	/// - returns: A coordinate object with the location of the subject of the Wikipedia article.
	class func getThumbnailForArticlesWithTitle(titles: [String], completion: (imageUrls: [NSURL]) -> () ) {
		if titles.count <= 0 {
			completion(imageUrls: [NSURL]())
			return
		}
		
		var titleConcat = ""
		
		for title in titles {
			titleConcat += title + "|"
		}
		titleConcat = String(titleConcat.characters.dropLast())
		
		var urlString = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&pilimit=\(titles.count)&pithumbsize=150&format=json&titles=\(titleConcat)"
		urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
		let url = NSURL(string: urlString)
		if url == nil {
			print("error creating URL from string: \(urlString)")
			completion(imageUrls: [NSURL]())
			return
		}
		
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(
			configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
			delegate: nil,
			delegateQueue:  NSOperationQueue.mainQueue()
		)
		
		let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
		  completionHandler: { (dataOrNil, response, error) in
			if error != nil {
				print("error getting thumbnail for article:\n\(error?.localizedDescription)")
				completion(imageUrls: [NSURL]())
				return
			}
			
			do {
				if let data = dataOrNil {
					if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
						if let pages = responseDictionary["query"]?["pages"] as? NSDictionary {
							let pageIds = pages.allKeys as! [String]
							
							var imageUrls = [NSURL]()
							
							for pageId in pageIds {
								let page = pages[pageId]
								
								if page?.objectForKey("thumbnail") != nil {
									let thumbnail = page!["thumbnail"] as! NSDictionary
									
									imageUrls.append(NSURL(string: thumbnail["source"] as! String)!)
								}
							}
							
							completion(imageUrls: imageUrls)
						}
					}
				}
			} catch let error as NSError {
				print("error parsing response, getting coordinates.\n\(error)")
			}
			
			completion(imageUrls: [NSURL]())
		});
		task.resume()
	}
}