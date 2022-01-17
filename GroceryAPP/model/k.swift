//
//  k.swift
//  GroceryAPP
//
//  Created by DvOmar on 09/06/1443 AH.
//

import Foundation
struct K {
    static let cellItem="cellItem"
    static let cellUsers="cellUsers"
    struct Segue{
        static let toListGroceries="toListGroceries"
        static let toOnlineUsers="toOnlineUsers"
    }
    struct GroceryItem{
        static let GroceryItems="Grocery-Items"
        static let addByUser="addByUser"
        static let completed="completed"
        static let item="item"
        static let uid="uid"

    }
    
    static var isOnline = false
    static var isLoged = false
    
    // firebase
    static let users="users"
    struct UserOnline{
        static let uid="uid"
        static let email="email"
        static let isOnline="isOnline"
    }
}

