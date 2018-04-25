//
//  SavedPhotosTableViewController.swift
//  VKPhotoFriends
//
//  Created by Igor Grankin on 25.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit
import CoreData

class SavedPhotosTableViewController: UITableViewController {
    var photoArrays: Array<Dictionary<String, AnyObject>> = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let author = data.value(forKey: "author") as! String
                let date = data.value(forKey: "date") as! String
                let avatar = data.value(forKey: "avatar") as! UIImage
                let image = data.value(forKey: "image") as! UIImage
                photoArrays.append(["name": author as AnyObject,
                                     "date":date as AnyObject,
                                     "image": image as AnyObject,
                                     "avatar": avatar as AnyObject])
            }
        } catch {
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (photoArrays.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhotoID", for: indexPath) as! VKPhotoCell
        if (photoArrays.count == 0) {
            cell.nameLabel.text = " "
        } else {
            cell.nameLabel.text = photoArrays[indexPath.row]["name"] as! String
            cell.avatarImage.image = photoArrays[indexPath.row]["avatar"] as! UIImage
            cell.photoImage.contentMode = .scaleAspectFit
            cell.photoImage.image = photoArrays[indexPath.row]["image"] as! UIImage
            cell.dateLabel.text = photoArrays[indexPath.row]["date"] as! String
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
