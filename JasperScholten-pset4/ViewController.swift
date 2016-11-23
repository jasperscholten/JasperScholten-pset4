//
//  ViewController.swift
//  JasperScholten-pset4
//
//  Created by Jasper Scholten on 20-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

// Add by clicking add button
// Delete by swiping left - commitEditingStyle delegate function
// Check (done) by swiping right
// Rmember list between sessions

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    private let db = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if db == nil {
            print("Error")
        }
        
        /*do {
            try db!.addColumn(check)
        } catch {
            print(error)
        }*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        do {
            count = try db!.countRows()
        } catch {
            print(error)
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! TodoItemCell
        
        do {
            cell.listItem.text = try db!.populate(index: indexPath.row)
            print("Table: \(try db!.populateCheck(index: indexPath.row))")
        } catch {
            print(error)
        }
            
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try db!.delete(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                // try db!.updateCheck(index: indexPath.row)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        do {
            try db!.add(item: inputField.text!)
            inputField.text = ""
            
            // How to insert instead of updating complete table?
            self.tableView.reloadData()

            // self.tableView.reloadRows(at: [index], with: .none)
            
        } catch {
            print("Error thrown:")
            print(error)
        }
    }

}

