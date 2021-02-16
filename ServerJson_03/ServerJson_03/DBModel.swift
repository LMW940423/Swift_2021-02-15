//
//  DBModel.swift
//  ServerJson_03
//
//  Created by 이민우 on 2021/02/15.
//

import Foundation

class DBModel : NSObject{
    // Propertis
    var sCode : String?
    var sName : String?
    var sDept : String?
    var sPhone : String?
    
    // Empty Constructor
    override init() {
        
    }
    
    init(sCode : String, sName : String, sDept : String, sPhone : String){
        self.sCode = sCode
        self.sName = sName
        self.sDept = sDept
        self.sPhone = sPhone
    }
}

