//
//  ViewController.swift
//  JasperScholten-pset4
//
//  Created by Jasper Scholten on 20-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    private let db = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Method to dismiss keyboard upon tap outside keyboard. Uses func dismissKeyboard() http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if db == nil {
            print("Error")
        }
        
        // Method to check if it's the first time an app is launched (after a fresh install). http://stackoverflow.com/questions/30635160/how-to-check-if-the-ios-app-is-running-for-the-first-time-using-swift
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            print("Already launched")
        }
        else
        {
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
        
        // Method to retrieve the indexpath of the cell that the user clicks on. http://stackoverflow.com/questions/39603922/getting-row-of-uitableview-cell-on-button-press-swift-3
        let switchPos = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: switchPos)
        
        do {
            try db!.checkSwitch(index: indexPath!.row)
        } catch {
            print(error)
        }
    }
    
    // 
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

