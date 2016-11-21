//
//  DatabaseHelper.swift
//  JasperScholten-pset4
//
//  Created by Jasper Scholten on 21-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let todo = Table("todo")
    
    private let id = Expression<Int64>("id")
    private let item = Expression<String?>("item")
    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
        
    }
    
    private func createTable() throws {
        
        do {
            
            try db!.run(todo.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(item)
            })
        } catch {
            throw error
        }
    
    }
    
    func add(item: String) throws {
        
        let insert = todo.insert(self.item <- item)
        
        do {
            let rowId = try db!.run(insert)
            print(rowId)
        } catch {
            throw error
        }
        
    }
    
    /*func populate() throws -> Array<Row> {
        
        var result: Array<Row>
        
        do {
            result = Array(try db!.prepare(todo))
            print(result)
        } catch {
            throw error
        }
     
        return result
        
    }*/
    
    func populate() throws -> String? {
        
        var result: String?
        
        do {
            for list in try db!.prepare(todo) {
                result = "\(list[item]!)"
                print(result ?? "Something went wrong")
            }
        } catch {
            throw error
        }
        
        return result
        
    }
    
    func countRows() throws -> Int {
        return try db!.scalar(todo.count)
    }
    
}
