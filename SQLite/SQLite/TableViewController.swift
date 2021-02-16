//
//  TableViewController.swift
//  SQLite
//
//  Created by 이민우 on 2021/02/15.
//

import UIKit
import SQLite3

class TableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    
    // db
    var db : OpaquePointer?
    var studentsList : [Students] = []
//    var studentsList = [Students]
    
    override func viewDidLoad() {
        super.viewDidLoad()

      // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("StudentsData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        // 테이블 없으면 만들고 있으면 패스
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS students (sId INTEGER PRIMARY KEY AUTOINCREMENT, sName TEXT, sDept TEXT, sPhone TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errmsg)")
        }
        
        // Temporary Insert
//        tempInsert()
        
        // Table 내용 불러오기
        readValues()
    }
    
    // DB INSERT
    func tempInsert(){
        var stmt : OpaquePointer?
        // 중요 (한글 문제 해결)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "INSERT INTO students (sName, sDept, sPhone) VALUES (?, ?, ?)"
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return
        }
        
        // ?에 값을 넣는 것 (컬럼마다 if로 체크해주는 것이 좋다)
        if sqlite3_bind_text(stmt, 1, "유비", -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding name : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, "컴퓨터공학과", -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding dept : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, "010-3046-3035", -1, SQLITE_TRANSIENT) != SQLITE_OK{
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
        
        print("Student saved successfully")
        
    }
    
    // DB SELECT
    func readValues(){
        studentsList.removeAll()
        
        let queryString = "SELECT * FROM students"
        var stmt : OpaquePointer?
        
        // &stmt 에 ?에 대응하는 값을 넣어주면 된다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errmsg)")
            return
        }
        
        // 읽어올 행이 있으면 데이터 가져오기
        while sqlite3_step(stmt) == SQLITE_ROW{
            let id = sqlite3_column_int(stmt, 0) //
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let dept = String(cString: sqlite3_column_text(stmt, 2))
            let phone = String(cString: sqlite3_column_text(stmt, 3))

            print(id, name, dept, phone)
            
            // 한글 포함된 경우 describing
            studentsList.append(Students(id: Int(id), name: String(describing : name), dept: String(describing : dept), phone: String(describing : phone)))
        }
        self.tvListView.reloadData() // tableview관련 함수들을 실행시킨다. (화면 갱신)
    }
    
    // 넘어온 화면일 때 처리하는 화면 (다시 화면 갱신)
    override func viewWillAppear(_ animated: Bool) {
        readValues() // db에서 다시 읽어오고
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        let students : Students
        students = studentsList[indexPath.row]
        
        cell.textLabel?.text = "학번 : \(students.id)"
        cell.detailTextLabel?.text = "성명 : \(students.name!)" // 데이터가 없을 수도 있으므로 optional

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            
//            let item : Students = studentsList[(indexPath! as NSIndexPath).row]
            let item : Students = studentsList[indexPath!.row] // 이렇게 써도 된다.
            
            let sId = item.id
            let sName = item.name
            let sDept = item.dept
            let sPhone = item.phone
            
            detailView.receiveItems(sId, sName, sDept, sPhone)
            
        }
    }
    

}
