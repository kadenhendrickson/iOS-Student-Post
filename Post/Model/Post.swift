//
//  Post.swift
//  Post
//
//  Created by Kaden Hendrickson on 5/13/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class Post: Codable {
    
    let text: String
    var timestamp: TimeInterval 
    let username: String
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970){
        self.text = text
        self.username = username
        self.timestamp = timestamp
        
    }
}
