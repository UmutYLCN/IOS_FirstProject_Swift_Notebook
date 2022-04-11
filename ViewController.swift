//
//  ViewController.swift
//  notebookapplication
//
//  Created by umut yalçın on 25.02.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var titleList = [String]()
    var idList = [UUID]()
    
    
    var selectedtitle = ""
    var selectedId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        
        GetData()
    }
    
    
    @objc func addNote(){
        selectedtitle = ""
        
        performSegue(withIdentifier: "toAddPageVC", sender: nil)
    }
    
    
    @objc func GetData(){
        
        titleList.removeAll(keepingCapacity: false)
        idList.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let datas = try context.fetch(fetchRequest)
            
            for data in datas as! [NSManagedObject] {
                
                if let title = data.value(forKey: "title") as? String {
                    
                    titleList.append(title)
                    
                }
                
                if let id = data.value(forKey: "id") as? UUID {
                    
                    idList.append(id)
                }
                
                
            }
            tableView.reloadData()
            
        }catch {
            print("There is an error while inserting the data into the array.")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(GetData), name: NSNotification.Name(rawValue: "DataEntered"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell =  UITableViewCell()
            cell.textLabel?.text = titleList[indexPath.row]
            return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPageVC" {
            let destinationVC = segue.destination as? AddNoteViewController
            destinationVC?.IncomingDataTitle = selectedtitle
            destinationVC?.IncomingDataId = selectedId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedtitle = titleList[indexPath.row]
        selectedId = idList[indexPath.row]
        performSegue(withIdentifier: "toAddPageVC", sender: nil)
    }
    
    
    // Delete
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notebook")
            let uuidString = idList[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do {
                let datas = try context.fetch(fetchRequest)
                
                if datas.count > 0 {
                    
                    for data in datas as! [NSManagedObject] {
                        
                        if let id =  data.value(forKey: "id") as? UUID {
                            if id == idList[indexPath.row] {
                                
                                context.delete(data)
                                titleList.remove(at: indexPath.row)
                                idList.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do {
                                    
                                    try context.save()
                                    
                                }catch{
                                    
                                }
                                break
                            }
                        }
                        
                    }
                    
                }
                
                
            }catch {
                
            }
            
        }
    }
    
    
   
    
    
    
    
    
    
    


}


