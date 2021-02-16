//
//  Students.swift
//  SQLite
//
//  Created by 이민우 on 2021/02/15.
//

import Foundation

class Students{
    // key로 잡을 값은 무조건 값이 존재해야 하므로 optional을 쓰지 않는다.
    var id : Int
    var name : String?
    var dept : String?
    var phone : String?
    
    // 생성자
    init(id : Int, name : String?, dept : String?, phone : String?) {
        self.id = id
        self.name = name
        self.dept = dept
        self.phone = phone
    }
}


