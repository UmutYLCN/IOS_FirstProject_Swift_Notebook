//
//  AddNoteViewController.swift
//  notebookapplication
//
//  Created by umut yalçın on 25.02.2022.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController  ,UINavigationControllerDelegate{

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var titletext: UITextField!
    
    @IBOutlet weak var notetext: UITextView!
    
    
    @IBOutlet weak var button: UIButton!
    
    var IncomingDataTitle = ""
    var IncomingDataId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if IncomingDataTitle != "" {
            
            label.text = "Update Note"
            button.setTitle("Update", for: .normal)
            
            
            if let uuidString = IncomingDataId?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let context = appDelegate?.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
                fetchRequest.predicate = NSPredicate(format: "id = %@ ", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                
                do {
                    
                    let datas = try context?.fetch(fetchRequest)
                   
                    if datas!.count > 0 {
                        
                        for data in datas as! [NSManagedObject]{
                            
                            if let title = data.value(forKey: "title") as? String{
                                titletext.text = title
                                
                            }
                            
                            if let note = data.value(forKey: "note") as? String {
                                notetext.text = note
                            }
                            
                            
                            
                        }

                    }
                    
                }catch{
                    
                }
                
                
            }
            
            
            
        }else {
            titletext.text = ""
            notetext.text = ""
        }
        
        
        
        
        
    
    }
    
   
    @IBAction func AddNoteClicked(_ sender: Any) {
        
        
        if IncomingDataTitle != "" {
            
            
            updateData()
        }else{
            SaveData()
        }
        
        
    }
    
    
    func SaveData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let NoteList = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context)
        
        
        
        NoteList.setValue(titletext.text, forKey: "title")
        
        NoteList.setValue(notetext.text, forKey: "note")
        NoteList.setValue(UUID(), forKey:"id")
        
        
        do {
            try context.save()
        }catch{
            print("There is an error while sending data to core data.")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataEntered"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    func updateData(){
         
        if IncomingDataTitle != "" {
            
            if let uuidString = IncomingDataId?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Notebook")
                fetchRequest.predicate = NSPredicate(format: "id = %@ ", uuidString)

                do {
                    let test = try context.fetch(fetchRequest)
                    let objectUpdate = test[0] as! NSManagedObject
                    
                    objectUpdate.setValue(titletext.text, forKey: "title")
                    objectUpdate.setValue(notetext.text, forKey: "note")
                    
                    do {
                        try context.save()
                    }
                    catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
        
        
    }
    
}

