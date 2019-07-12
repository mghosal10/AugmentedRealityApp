//
//  SpeciesViewController.swift
//  AugRealApp
//
//  Created by Madhumita Ghosal on 6/6/19.
//  Copyright © 2019 Madhumita Ghosal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class SpeciesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [species]()
    var dbRef: DatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
        dbRef = Database.database().reference().child("image data")
        loadDatabase()
        
    }
    
    func loadDatabase()
    {
        dbRef.observe(DataEventType.value) { (snapshot) in
            var newImages = [species]()
            
            for speciesSnapshot in snapshot.children{
                let speciesObj = species(snapshot: speciesSnapshot as! DataSnapshot)
                newImages.append(speciesObj)
            }
            self.images = newImages
            self.collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SpeciesCollectionViewCell
        
        let image = images[indexPath.row]
       // cell.speciesImageView.image = self.newimages[indexPath.item]
        
        cell.speciesImageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named:"nature"))
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
