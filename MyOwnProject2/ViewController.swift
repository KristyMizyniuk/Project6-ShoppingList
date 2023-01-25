//
//  ViewController.swift
//  MyOwnProject2
//
//  Created by Христина Мізинюк on 11/21/22.
//

import UIKit

class ViewController: UIViewController {
    
    var shoppingList = [String]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshShoppingList))
        
        self.title = "My shopping list"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if  !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
            
        }
       updateShoppingList()
    }
    
    @objc func refreshShoppingList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        for x in 0..<count {
            
            UserDefaults().removeObject(forKey: "shoppingList_\(x+1)")
        }
        
    }
    func updateShoppingList() {
        
        shoppingList.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        for x in 0..<count {
            
            if let shoppingLists = UserDefaults().value(forKey: "shoppingList_\(x+1)") as? String {
                shoppingList.append(shoppingLists)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.tintColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        vc.title = "Purchases"
        vc.update = {
            DispatchQueue.main.async {
                self.updateShoppingList()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let row =  Int(indexPath.row.description)! + 1
            
            guard let count = UserDefaults().value(forKey: "count") as? Int else {
                return
            }
            for _ in 0..<count {
                
                UserDefaults().removeObject(forKey: "shoppingList_\(row)")
            }
            
            shoppingList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}


