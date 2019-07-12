//
//  SpeciesCollectionViewCell.swift
//  
//
//  Created by Madhumita Ghosal on 6/8/19.
//

import UIKit

class SpeciesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var speciesImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.speciesImageView.image = nil
    }
}
