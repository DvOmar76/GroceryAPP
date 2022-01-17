//
//  Functions.swift
//  GroceryAPP
//
//  Created by DvOmar on 11/06/1443 AH.
//

import Foundation
import Firebase
import UIKit
import GoogleSignIn
struct Functions{
static var rf = Database.database().reference()
    
    
    // MARK: -------------------------( Login VC )--------------------------------
    
   static func ShowError(fieldError:UILabel,text:String){
        fieldError.text=text
        fieldError.textColor=UIColor.red
    }
    
    static func CreateNewUser(email:String,password:String,loginVC:LoginVC)
    {
        Auth.auth().createUser(withEmail: email, password: password) { resulet, error in
            if error != nil
            {
                // show error
                ShowError(fieldError: loginVC.fieldError, text: error!.localizedDescription)
            }
            else
            {
                setValuIsLoged(value: true)

                loginVC.performSegue(withIdentifier: K.Segue.toListGroceries, sender: loginVC.self)

            }
    }

    }
    
    static func checkFields(list:[String])->String?{
        for field in list{
            if field == "" {
                return "please fill in all fialds"
            }
        }
        // if fields is not empty
          return nil
    }
   
   static func signIn(email:String,password:String,loginVC:LoginVC){
        //  check fields
       
        let check = checkFields(list:[email,password])
        if check == nil
        {
            //  singin in firebase
            Auth.auth().signIn(withEmail: email,password:password)
            {
                authResult, Error in
                if Error != nil
                {
                    Functions.ShowError(fieldError: loginVC.fieldError, text: Error!.localizedDescription)

                }
                else
                {
                    setValuIsLoged(value: true)
                    loginVC.performSegue(withIdentifier: K.Segue.toListGroceries, sender: loginVC.self)
                    loginVC.fieldError.text=""
                }
            }
        }
        else
        {
            Functions.ShowError(fieldError:loginVC.fieldError, text:check!)
        }
    }
    
    static func signUp(email:String,password:String,loginVC:LoginVC){
        let chack=Functions.checkFields(list: [email,password])
        if chack  == nil
        {
            loginVC.fieldError.text=""
            CreateNewUser(email: email, password: password,loginVC: loginVC.self)
        }
        else
        {
            ShowError(fieldError: loginVC.fieldError, text: chack!)
        }
    }
    static func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
    static func login (loginVC:LoginVC){
        //google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { user, error in
            if let error = error {
                //show errors to the user
                Functions.ShowError(fieldError: loginVC.fieldError, text: error.localizedDescription)
                return
              }

              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            //Firebase Auth
            Auth.auth().signIn(with: credential){result,error in
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                //displaying User Name
                guard let user = result?.user else{
                    return
                }
                
                
                loginVC.performSegue(withIdentifier: K.Segue.toListGroceries, sender: loginVC.self)

                print(user.displayName ?? "Succes!")
            }
        }
    }

    
    // MARK: -------------------------( GroceryItemVC )--------------------------------
    
   static func checkField(item:String )->String?{
        if item == ""
        {
            return "please enter new item"
        }
        // if fields is not empty
          return nil
    }
    
    static  func editItemName(text:String,uid:String){
        rf.keepSynced(true)
        let email=Auth.auth().currentUser?.email
        rf.child(K.GroceryItem.GroceryItems).child(uid).child(K.GroceryItem.item).setValue(text)
        rf.child(K.GroceryItem.GroceryItems).child(uid).child(K.GroceryItem.addByUser).setValue(email)

    }
   
    
    static func checkMark(sender:UIButton,uid:String,completed:String,groceryItemVC:GroceryItemVC){
        rf.keepSynced(true)

        if completed == "true" {groceryItemVC.marked = true}
        else{ groceryItemVC.marked = false}
       
        if groceryItemVC.marked
        {
            print("inside if")
            print("Unchecked")
            sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            rf.child(K.GroceryItem.GroceryItems).child(uid).child(K.GroceryItem.completed).setValue("false")
          
        }
        else
        {
            print("inside else")
            print("checked")
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            rf.child(K.GroceryItem.GroceryItems).child(uid).child(K.GroceryItem.completed).setValue("true")
        }
    }
    static func deleteItem(uid:String){
        rf.keepSynced(true)
        rf.child(K.GroceryItem.GroceryItems).child(uid).removeValue()
    }
    
    
    // MARK: -------------------------( GroceriesTVC & GroceryItemVC  )--------------------------------

    
    static func showDialog(
        title: String? = nil,
        subtitle: String? = nil,
        actionTitle: String? = "Add",
        cancelTitle: String? = "Cancel",
        item: String? = nil,
        inputPlaceholder: String? = nil,
        groceryItemVC:GroceryItemVC? = nil,
        groceriesTVC:GroceriesTVC? = nil,
        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
        uid:String? = nil,
        isEdditItem:Bool,
        actionHandler: ((_ text: String?) -> Void)? = nil)
        {
                   let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
                   alert.addTextField { (textField:UITextField) in
                       textField.text = item
                       textField.placeholder = "Enter new Item"
                   }
            
                   alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
                       guard let itemName = alert.textFields?[0]

                       else
                       {
                           actionHandler?(nil)
                           return
                       }
                       actionHandler?(itemName.text)
                            //   check Field
                       if  checkField(item:itemName.text!) == nil {
                           //    if is eddit item it will take editItem func  else take addItem func
                           if isEdditItem{
                               editItemName(text: itemName.text!,uid: uid!)
                           }
                           else
                           {
                               addItemToFireBase(newitem: itemName.text!)

                           }
                       }
               
                   }))
                   alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
           
            if isEdditItem
            {
                groceryItemVC!.viewController?.present(alert, animated: true, completion: nil)
            }
            else
            {
                groceriesTVC!.present(alert, animated: true, completion: nil)

            }

        }
     
     
    // MARK: -------------------------( GroceriesTVC )--------------------------------
        static func addItemToFireBase(newitem:String)
        {
            rf.keepSynced(true)

            let email=Auth.auth().currentUser?.email
            let uid=UUID().uuidString
            let item : [String:Any] = [
                K.GroceryItem.addByUser:email!,
                K.GroceryItem.completed:"false",
                K.GroceryItem.item:newitem,
                K.GroceryItem.uid:uid
            ]
            
            rf.child(K.GroceryItem.GroceryItems).child(uid).setValue(item)

        }
    
        static func loadItems(groceriesTVC:GroceriesTVC)
        {
                rf.keepSynced(true)
                print("in side load item ")
                rf.child(K.GroceryItem.GroceryItems).queryOrdered(byChild: K.GroceryItem.item).observe(DataEventType.value)
            {
                DataSnapshot in
                
                GroceriesTVC.listItems=[]
                if let list = DataSnapshot.value as? [String:[String:Any]]
                {
        //              print("in side load item - in side if  ")
        //                print("------------\(list.keys)--------------")
                        
                    for item in list
                    {
                            print(item.value)
                            GroceriesTVC.listItems.append(item.value)
                    }
                    
                    DispatchQueue.main.async
                    {
                            groceriesTVC.tableView.reloadData()
                    }
                        
                }
            }
        }
    static func userIsOnline(){
        rf.keepSynced(true)
        if let uid=Auth.auth().currentUser?.uid ,let email=Auth.auth().currentUser?.email{
            let user : [String:Any] = [
                K.UserOnline.email:email,
                K.UserOnline.isOnline:true
            ]
            print("online")
            rf.child(K.users).child(uid).setValue(user)
        }
    }
    
    static func itemCell(cell:GroceryItemVC,indexPathrRow:Int,groceriesTVC:GroceriesTVC){
        cell.viewController = groceriesTVC.self
        if GroceriesTVC.listItems.count != 0
        {
            cell.titleItem.text=GroceriesTVC.listItems[indexPathrRow][K.GroceryItem.item] as? String
            cell.btnCheckMark.tag=indexPathrRow
            if GroceriesTVC.listItems[indexPathrRow][K.GroceryItem.completed] as! String == "true"
            {
//                print(GroceriesTVC.listItems[indexPath.row][K.GroceryItem.completed] as! String )
                cell.btnCheckMark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
            else
            {
//                print(GroceriesTVC.listItems[indexPath.row][K.GroceryItem.completed] as! String )
                cell.btnCheckMark.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            cell.createdBy.text=GroceriesTVC.listItems[indexPathrRow][K.GroceryItem.addByUser] as? String
//            print(listItems[indexPath.row])
        }
    }
    
    // MARK: -------------------------( OnlineTV )--------------------------------

        static func loadUsers(onlineTVC:OnlineTVC){
        rf.keepSynced(true)
        rf.child(K.users).observe(DataEventType.value) { DataSnapshot in
                
                GroceriesTVC.listItems=[]
                if let list = DataSnapshot.value as? [String:[String:Any]]
                {
                    for item in list {
                        print(item.value)
                        onlineTVC.listUsers.append(item.value)
                    }
                    DispatchQueue.main.async {
                        onlineTVC.tableView.reloadData()
                    }
                    
                }
            }
        }
    
    //------------
    static func signOut(){
        let rf = Database.database().reference()
        if let uid=Auth.auth().currentUser?.uid{
            print("offline")
            rf.child(K.users).child(uid).removeValue()
        }
    }
    
    static func setValuIsLoged(value:Bool){
        let defaults = UserDefaults.standard
        K.isLoged=value
        //Set
        defaults.set(K.isLoged, forKey: "isLoged")
    }
   
    
}
