//
//  FlickrHelper.swift
//  FlickrSearch
//
//  Created by Mavericks on 17/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit

class FlickrHelper: NSObject {

    class func urlForSearchString (searchStr: String) -> String {
        let apiKey: String = "5b6647b718e00c0222d2685ac6349e5f"
        let search: String = searchStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=20&format=json&nojsoncallback=1"
    }
    
    class func urlForFlickrPhoto (photo: FlickrPhoto , size: String) -> String {
        
        var _size = size
        
        if _size.isEmpty {
            _size = "m"
        }
        
        return "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.photoId)_\(photo.secret)_\(_size).jpg"
    }
    
    func searchFlickrForString (searchString: String , completion: (searchStr: String!, flickrPhotos: NSMutableArray!, error: NSError!) -> ()) {
        
        let searchUrl = FlickrHelper.urlForSearchString(searchString)
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
        dispatch_async(queue) { () -> Void in
            var error: NSError?
            var resultString: String?
            do {
            
             resultString = try NSString(contentsOfURL: NSURL(string: searchUrl)!, encoding: NSUTF8StringEncoding) as String
                
            } catch {
                print("Empty Result String")
                resultString = nil
                completion(searchStr: searchString, flickrPhotos: nil, error: nil)
            }
            
            let jsonData: NSData! = resultString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var resultDict: NSDictionary!
            do {
             resultDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary
            } catch {
                print ("JSON Serialisation error")
                completion(searchStr: searchString, flickrPhotos: nil, error: nil)
            }
            
            let status = resultDict.objectForKey("stat") as! String
            
            if status == "fail" {
                print(resultDict.objectForKey("message"))
                completion(searchStr: searchString, flickrPhotos: nil, error: nil)
                
            } else {
                let resultArray: NSArray! = resultDict.objectForKey("photos")?.objectForKey("photo") as! NSArray
                
                let flickrPhotos:NSMutableArray = NSMutableArray()
                
                for photoObject in resultArray{
                    let photoDict:NSDictionary = photoObject as! NSDictionary
                    print(photoDict)
                    let flickrPhoto:FlickrPhoto = FlickrPhoto()
                    flickrPhoto.farm = photoDict.objectForKey("farm") as! Int
                    flickrPhoto.server = photoDict.objectForKey("server") as! String
                    flickrPhoto.secret = photoDict.objectForKey("secret") as! String
                    flickrPhoto.photoId = photoDict.objectForKey("id") as! String
                    
                    let searchPhotoUrl: String = FlickrHelper.urlForFlickrPhoto(flickrPhoto, size: "m")
                    let imgData: NSData = NSData(contentsOfURL: NSURL(string: searchPhotoUrl)!)!
                    
                    let image:UIImage = UIImage(data: imgData)!
                    
                    flickrPhoto.thumbnail = image
                    
                    flickrPhotos.addObject(flickrPhoto)
                    
                }
                completion(searchStr: searchString, flickrPhotos: flickrPhotos, error: nil)
            }
            
        }
        
    }
    
    
}
