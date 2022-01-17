//
//  GroceriesTVC.swift
//  GroceryAPP
//
//  Created by DvOmar on 09/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class GroceriesTVC: UITableViewController {
    var rf = Database.database().reference()
    
    static var listItems:[[String:Any]]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        Functions.loadItems(groceriesTVC: self)
        navigationItem.hidesBackButton=true
        rf.keepSynced(true)
//        let rf = Database.database().reference()
        Functions.userIsOnline()
    }
    override func viewDidAppear(_ animated: Bool) {
        Functions.loadItems(groceriesTVC: self)
    }
   
    @IBAction func clickOnAddBtn(_ sender: Any) {
        Functions.showDialog(title:"Grocery Item",subtitle: "add an item",groceriesTVC: self ,isEdditItem: false)
    }
    
    @IBAction func clickOnOlineUsers(_ sender: Any) {
        self.performSegue(withIdentifier: K.Segue.toOnlineUsers, sender: self)

    }
    
  
  
    
    // MARK: - Table view data source
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GroceriesTVC.listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellItem, for: indexPath) as! GroceryItemVC
        Functions.itemCell(cell: cell, indexPathrRow: indexPath.row, groceriesTVC: self)
        return cell
    }
    
    
   
   
}
