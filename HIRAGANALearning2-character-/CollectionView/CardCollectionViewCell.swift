//
//  CardCollectionViewCell.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/14.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var cardData: CardData!
    var editCard: EditCard!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.flatBrown.cgColor
        self.layer.borderWidth = 2.0
        self.backgroundColor = UIColor.flatSand
    }
    
    func createCard(_ cd:CardData){
        cardData = cd
        let image = cardData.image
        let text = cardData.word
        imageView.image = image
        label.text = text
    }
    
    func importCard(_ ec:EditCard){
        editCard = ec
        let image = UIImage(data: editCard.image! as Data)
        let word = editCard.word
        imageView.image = image
        label.text = word
    }
    
}
