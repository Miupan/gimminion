//
//  CardCell.swift
//  TalkCard
//
//  Created by 美羽 on 2021/08/25.
//

import UIKit

protocol CardCellDelegate: AnyObject {
    func editButtonPressed(title: String)
}

class CardCell:UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cardImageView: UIImageView!
    
    var delegate: CardCellDelegate?
    
    @IBAction func editButtonPressed() {
        delegate?.editButtonPressed(title: nameLabel.text ?? "")
    }
}
