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
            // cell.listItem.text = try db!.populate()
        } catch {
            print(error)
        }
            
        return cell
    
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        do {
            try db!.add(item: inputField.text!)
            
            /* Helemaal niet nodig...
            let newItem = try db!.populate()
            listItems.append(newItem!)*/
            
            // How to insert instead of updating complete table?
            self.tableView.reloadData()
            
            // let index = IndexPath.init(row: 1, section: 0)
            // self.tableView.reloadRows(at: [index], with: .none)
            
        } catch {
            print(error)
        }
    }

}

