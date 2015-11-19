//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Mavericks on 17/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit

class FlickrPhoto: NSObject {

    var thumbnail:UIImage!
    var largeImage: UIImage!
    
    var farm: Int!
    var server: String!
    var secret: String!
    var photoId: String!
    
    override init() {
        
    }
}
