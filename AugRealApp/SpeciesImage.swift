//
//  SpeciesImage.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/9/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import FirebaseDatabase

struct species
{
    let key: String!
    let url: String!
    
    let speciesRef: DatabaseReference?
    
    init(url: String, key: String) {
        self.key = key
        self.url = url
        self.speciesRef = nil
    }
    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        speciesRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let imageUrl = snapshotValue?["url"] as? String
        {
            url = imageUrl
        }
        else
        {
            url = ""
        }
        
    }
}
