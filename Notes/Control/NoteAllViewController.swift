//
//  NoteAllViewController.swift
//  Notes
//
//  Created by Ridwan Abdurrasyid on 02/07/19.
//  Copyright © 2019 Mentimun Mulus. All rights reserved.
//

import UIKit
import CoreData

class NoteAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [NoteData]()
    var isLoggedIn = false
    var username : String?
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = "default"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        isLoggedIn = defaults.bool(forKey: "isLoggedIn")
        loadLastUser()
        loadNotes()
        
        tableView.reloadData()
    }
    
    func loadLastUser(){
        if isLoggedIn {
            username = defaults.string(forKey: "lastUsername")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
            
            request.predicate = NSPredicate(format: "username == %@", username!)
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(request) as! [UserData]
                if let userData = result.first {
                    self.title = "\(userData.name!)'s Notes"
                }
            } catch {
                print("fetching failed")
            }
        }
        else {
            username = "default"
            self.title = "My Notes"
        }
    }

    func loadNotes(){
        let request : NSFetchRequest<NoteData> = NoteData.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", username!)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        do {
            notes = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        print(notes.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for : indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        performSegue(withIdentifier: "NoteSegue", sender: self)
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let note = context.object(with: notes[index].objectID)
            context.delete(note)
            self.notes.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            do{
                try context.save()
            }
            catch{
                print(error)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue"{
            let destination = segue.destination as! NoteEachViewController
            destination.objectID = notes[index].objectID
            destination.newNote = false
        }
    }

}
