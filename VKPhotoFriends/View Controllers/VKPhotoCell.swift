//
//  VKPhotoCell.swift
//  VKPhotoFriends
//
//  Created by Igor Grankin on 25.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class VKPhotoCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
