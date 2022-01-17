//
//  OnlineTVC.swift
//  GroceryAPP
//
//  Created by DvOmar on 09/06/1443 AH.
//

import UIKit
import FirebaseDatabase
class OnlineTVC: UITableViewController {
    var listUsers:[[String:Any]]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        Functions.loadUsers(onlineTVC:self)
    
    }
   
    @IBAction func clikOnSignOut(_ sender: Any) {
        Functions.setValuIsLoged(value: false)
        Functions.signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUsers.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUsers", for: indexPath)
        if listUsers.count != 0{
            cell.textLabel?.text = listUsers[indexPath.row][K.UserOnline.email] as! String?
        }
        return cell
    }
   

    

}
