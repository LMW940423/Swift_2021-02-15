//
//  AddViewController.swift
//  SQLite
//
//  Created by 이민우 on 2021/02/15.
//

import UIKit
import SQLite3

class AddViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDept: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var db : OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQLite 생성하기
          let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("StudentsData.sqlite")
          
          if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
              print("error opening database")
          }
    }
    
    @IBAction func btnInsert(_ sender: UIButton) {
        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dept = txtDept.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let queryString = "INSERT INTO students (sName, sDept, sPhone) VALUES (?, ?, ?)"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return
        }
        
        // ?에 값을 넣는 것 (컬럼마다 if로 체크해주는 것이 좋다)
        if sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding name : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, dept, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding dept : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, phone, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding phone : \(errmsg)")
            return
        }
        
        // 실행하기 (잘 끝나지 않았으면 에러 출력)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting : \(errmsg)")
            return
        }
        
        let resultAlert = UIAlertController(title: "결과", message: "입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: {ACTION in
            self.navigationController?.popViewController(animated: true) // 현재 화면 close
        })
        
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true, completion: nil)
        
        print("Student saved successfully")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
