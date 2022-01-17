//
//  GroceryItemVC.swift
//  GroceryAPP
//
//  Created by DvOmar on 10/06/1443 AH.
//

import UIKit
import Firebase
class GroceryItemVC: UITableViewCell {

    @IBOutlet weak var titleItem: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCheckMark: UIButton!
    weak var viewController: UIViewController?

    var marked=false
    let groceriesTVC=GroceriesTVC()
    var rf = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickCheckMark(_ sender: UIButton) {
       if let uid=GroceriesTVC.listItems[self.btnCheckMark.tag][K.GroceryItem.uid] as? String ,
            let completed=GroceriesTVC.listItems[self.btnCheckMark.tag][K.GroceryItem.completed] as? String {
           Functions.checkMark(sender: sender, uid: uid, completed: completed, groceryItemVC: self)

       }
    }
    @IBAction func editItem(_ sender: UIButton) {
        if let uid=GroceriesTVC.listItems[self.btnCheckMark.tag][K.GroceryItem.uid] as? String{
            Functions.showDialog(title:"edit item", groceryItemVC:self , uid: uid,isEdditItem: true)
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        if let uid=GroceriesTVC.listItems[self.btnCheckMark.tag][K.GroceryItem.uid] as? String{
            Functions.deleteItem(uid: uid)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
   
}
