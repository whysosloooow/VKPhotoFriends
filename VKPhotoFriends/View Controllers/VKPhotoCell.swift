//
//  VKPhotoCell.swift
//  VKPhotoFriends
//
//  Created by Igor Grankin on 25.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit
import CoreData

class VKPhotoCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(nameLabel.text, forKey: "author")
        newUser.setValue(dateLabel.text, forKey: "date")
        newUser.setValue(avatarImage.image, forKey: "avatar")
        newUser.setValue(photoImage.image, forKey: "image")
        appDelegate.saveContext()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
