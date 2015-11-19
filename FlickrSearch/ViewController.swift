//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Mavericks on 17/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var flickrLogo: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func searchPressed(sender: AnyObject) {
        searchTextField.resignFirstResponder()
        flickrLogo.backgroundColor = UIColor.blackColor()
        activity.startAnimating()
        
        let flickr: FlickrHelper = FlickrHelper()
        
        if searchTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Oops", message: "Please enter a search term", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            flickr.searchFlickrForString(searchTextField.text!, completion: { (searchStr: String!, flickrPhotos: NSMutableArray!, error: NSError!) -> () in
                if (error == nil) {
                    let flickrPhoto: FlickrPhoto = flickrPhotos.objectAtIndex(Int(arc4random_uniform(UInt32(flickrPhotos.count)))) as! FlickrPhoto
                    
                    let image:UIImage = flickrPhoto.thumbnail
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = image
                        self.activity.stopAnimating()
                        self.flickrLogo.backgroundColor = UIColor.clearColor()
                        
                    })

                }
            })
        }
        
    }
}

