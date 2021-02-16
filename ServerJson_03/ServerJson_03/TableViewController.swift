//
//  TableViewController.swift
//  ServerJson_03
//
//  Created by 이민우 on 2021/02/15.
//

import UIKit

class TableViewController: UITableViewController, JsonModelProtocol {
    
    @IBOutlet var listTableView: UITableView!
    
    var feedItem : NSArray = NSArray()
    var cellImage : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downLoadItems()

        let jsonModel = JsonModel()
        jsonModel.delegate = self
        jsonModel.downloadItems()
        
        listTableView.rowHeight = 134 // Cell 높이
        
        
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        let item : DBModel = feedItem[indexPath.row] as! DBModel
        cell.imageView?.image = cellImage
        cell.lblName?.text = "성명 : \(item.sName!)"
        cell.lblPhone?.text = "전화 : \(item.sPhone!)"
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func downLoadItems(){
        let url : URL = URL(string: "http://127.0.0.1:8080/Images/dog.jpeg")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default) // Tomcat과 연결
        
        // task를 closure를 이용한 정의
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloading")
                DispatchQueue.main.async { [self] in
                    cellImage = UIImage(data: data!)!
                    // png
//                    if let image = UIImage(data: data!){
//                        if let data = image.pngData(){
//                            let filename = self.getDocumentDirectory().appendingPathComponent("copy.png")
//                            try? data.write(to: filename) // 스마트폰에 copy.png 파일로 저장
//                        }
//                    }
                    
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){
                            let filename = self.getDocumentDirectory().appendingPathComponent("copy.jpeg")
                            try? data.write(to: filename) // 스마트폰에 copy.png 파일로 저장
                            print("Data is writed")
                            print(self.getDocumentDirectory()) // write위치 출력
                        }
                    }
                }
            }
        }
        task.resume() // task를 실행
    }
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
