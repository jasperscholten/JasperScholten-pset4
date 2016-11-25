//
//  ViewController.swift
//  JasperScholten-pset4
//
//  Created by Jasper Scholten on 20-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

// Add by clicking add button
// Delete by swiping left - commitEditingStyle delegate function
// Check (done) via UIswitch
// Rmember list between sessions

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    private let db = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db == nil {
            print("Error")
        }
        
        // http://stackoverflow.com/questions/30635160/how-to-check-if-the-ios-app-is-running-for-the-first-time-using-swift
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            // app already launched
            print("Already launched")
        }
        else
        {
            // This is the first launch ever
            print("First launch")
            do {
                try db!.add(item: "Type in todo field and click add")
                try db!.add(item: "Use switch to check todo")
                try db!.add(item: "Swipe left to delete item")
            } catch {
                print(error)
            }
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
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
            let checkState = try db!.populateCheck(index: indexPath.row)
            cell.checkSwitch.setOn(checkState, animated: true)
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

            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        do {
            try db!.add(item: inputField.text!)
            inputField.text = ""
            
            self.tableView.reloadData()
            
        } catch {
            print(error)
        }
    }

    @IBAction func checkItem(_ sender: Any) {
        
        // http://stackoverflow.com/questions/39603922/getting-row-of-uitableview-cell-on-button-press-swift-3
        let switchPos = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: switchPos)
        
        do {
            try db!.checkSwitch(index: indexPath!.row)
        } catch {
            print(error)
        }
    }
    
}

