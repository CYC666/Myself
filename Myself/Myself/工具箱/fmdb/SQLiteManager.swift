//
//  SQLiteManager.swift
//  Myself
//
//  Created by 曹老师 on 2018/6/27.
//  Copyright © 2018年 曹奕程. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    // 1.将类设计成单例
    static let shareInstance : SQLiteManager = SQLiteManager()
    
    // 保存数据库队列对象
    var dbQueue : FMDatabaseQueue = FMDatabaseQueue()
    
    func dataBase() -> FMDatabase {
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        path = path! + "/swiftLearn.sqlite"
        print(path!)
        return FMDatabase.init(path: path)
    }
    
    func createTable(tableName: String) {
        let db = dataBase()
        if db.open() {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS " + tableName + " ('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'age' INTEGER );"
            if !db.executeStatements(sql_stmt) {
                print("Error: \(db.lastErrorMessage())")
            }
            db.close()
        } else {
            print("Error: \(db.lastErrorMessage())")
        }
        db.close()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
