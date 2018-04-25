//
//  VKPhotosTableViewController.swift
//  VKPhotoFriends
//
//  Created by Igor Grankin on 25.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit
import VK_ios_sdk
import SwiftyJSON
import MBProgressHUD
import SDWebImage

class VKPhotosTableViewController: UITableViewController {
    var progressHUD: MBProgressHUD?
    var photoArrays: Array<Dictionary<String, AnyObject>>?
    var sectionsNumber: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD?.mode = .determinate
        progressHUD?.label.text = "Загружаем последние картинки"
        let getNewPhotos = VKRequest.init(method: "newsfeed.get", parameters: ["filters": "photo, wall_photo", "max_photos": "1", "source_ids": "friends", "fields": "id, first_name, last_name, photo_50", "count": "100"])
        getNewPhotos?.execute(resultBlock: { (response) in
//            print(response ?? "wow")
            self.createPhotosArray(response: response!)
        }, errorBlock: { (error) in
            print("yay")
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (sectionsNumber == nil) {
            return 0
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (photoArrays?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhotoID", for: indexPath) as! VKPhotoCell
        if (photoArrays?.count == 0) {
            cell.nameLabel.text = " "
        } else {
            cell.nameLabel.text = photoArrays![indexPath.row]["name"] as! String
            cell.avatarImage.sd_setImage(with: URL(string: photoArrays![indexPath.row]["avatar"] as! String), completed: nil)
            cell.photoImage.contentMode = .scaleAspectFit
            cell.photoImage.sd_setImage(with: URL(string: photoArrays![indexPath.row]["photo_url"] as! String), completed: nil)
            cell.dateLabel.text = photoArrays![indexPath.row]["date"] as! String
        }
        return cell
    }

    
    func createPhotosArray(response: VKResponse<VKApiObject>) {
        if (response != nil) {
            photoArrays = []
            let jsonFromResponse = JSON(response.json)
            let profiles = jsonFromResponse["profiles"].arrayValue.map({$0})
            let pictures = jsonFromResponse["items"].arrayValue.map({$0["photos"]["items"][0]["photo_604"]})
            let picturesId = jsonFromResponse["items"].arrayValue.map({$0["photos"]["items"][0]["owner_id"]})
            let date = jsonFromResponse["items"].arrayValue.map({$0["photos"]["items"][0]["date"]})
            
            for index in 0..<pictures.count {
                for profile in profiles {
                    if (profile["id"] == picturesId[index]) {
                        let date = Date(timeIntervalSince1970: date[index].doubleValue)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                        let strDate = dateFormatter.string(from: date)
                        photoArrays?.append(["name": profile["first_name"].stringValue + " " + profile["last_name"].stringValue as AnyObject,
                                             "photo_url":pictures[index].stringValue as AnyObject,
                                            "date": strDate as AnyObject,
                                            "avatar": profile["photo_50"].stringValue as AnyObject])
                    }
                }
            }
            
            self.progressHUD?.hide(animated: true)
            if ((photoArrays?.count)! > 0) {
                sectionsNumber = photoArrays?.count
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
}
