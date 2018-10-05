//
//  ChatViewCell.swift
//  ParseChat
//
//  Created by Luis Mendez on 10/3/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import Parse

class ChatViewCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var adorableAvatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Chat Bubble Style Design
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
