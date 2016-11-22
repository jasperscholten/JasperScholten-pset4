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
    
    func countRows() throws -> Int {
        do {
            return try db!.scalar(todo.count)
        } catch {
            throw error
        }
    }
    
    func populate(index: Int) throws -> String? {
        
        var result: String?
        var count = 0
        
        do {
            for list in try db!.prepare(todo) {
                if count == index {
                    result = "\(list[item]!)"
                    // print("Test: \(result ?? "Something went wrong")")
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return result
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
    
    
    func delete(index: Int) throws {
        
        var rowID: Int64
        rowID = 0
        var count = 0
        
        do {
            for row in try db!.prepare(todo.select(id)) {
                if count == index {
                   rowID = row[id]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let item = todo.filter(id == rowID)
        
        do {
            let number = try db!.run(item.delete())
            print("\(number) row deleted")
        } catch {
            print(error)
        }
    }
 
}
