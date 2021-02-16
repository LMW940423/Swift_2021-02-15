//
//  JsonModel.swift
//  ServerJson_03
//
//  Created by 이민우 on 2021/02/15.
//

import Foundation

protocol JsonModelProtocol : class{
    func itemDownloaded(items : NSArray)
}

class JsonModel : NSObject{
    var delegate : JsonModelProtocol!
    let urlPath = "http://127.0.0.1:8080/IOS/student.json"
    
    func downloadItems(){
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloading")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data : Data){
        var jsonResult = NSArray()
        
        do{
            // 파싱한 데이터를 나눠서 넣은 것
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary // dictionary 타입으로 바꿔준다.
            let query = DBModel()
            
            // 파싱한 값을 빈에 저장하기
            if let sCode = jsonElement["code"] as? String,
               let sName = jsonElement["name"] as? String,
               let sDept = jsonElement["dept"] as? String,
               let sPhone = jsonElement["phone"] as? String{
                query.sCode = sCode
                query.sName = sName
                query.sDept = sDept
                query.sPhone = sPhone
            }
            locations.add(query) // query의 sCode,sName,sDept,sPhone이 한 줄씩 들어가 있다.
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations) // protocol에 값 넣기 (TableViewController에서 불러오기 위함)
        })
    }
}
