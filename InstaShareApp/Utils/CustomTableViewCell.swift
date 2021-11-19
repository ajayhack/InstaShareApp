//
//  CustomTableViewCell.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 06/11/21.
//

import UIKit

protocol CustomTableViewDelegate : AnyObject{
    func didLikeButtonTap(index : Int)
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var userNameLabel : UILabel? = nil
    @IBOutlet var locationLabel : UILabel? = nil
    @IBOutlet var descriptionLabel : UILabel? = nil
    @IBOutlet var postImage : UIImageView? = nil
    @IBOutlet var likeButton : UIButton? = nil
    @IBOutlet var sharebutton : UIButton? = nil
    
    weak var delegate : CustomTableViewDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    @IBAction func didLikeButtonTap(_ sender : UIButton){
        delegate?.didLikeButtonTap(index: sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
