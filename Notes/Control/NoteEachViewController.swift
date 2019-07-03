//
//  NoteEachViewController.swift
//  Notes
//
//  Created by Ridwan Abdurrasyid on 02/07/19.
//  Copyright © 2019 Mentimun Mulus. All rights reserved.
//

import UIKit
import CoreData

class NoteEachViewController: UIViewController {

    @IBOutlet weak var textOutlet: UITextView!
    @IBOutlet weak var titleOutlet: UITextField!
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var managedObjectContext : NSManagedObjectContext?
    
    var username = "default"
    var objectID : NSManagedObjectID?
    var newNote = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        loadLastUser()
        loadNote()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
        
    }

    func loadLastUser(){
        let isLoggedIn =  defaults.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            username = defaults.string(forKey: "lastUsername")!
        }
    }
    
    func loadNote(){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 15
        let attribute = [NSAttributedString.Key.paragraphStyle : style]
        
        if newNote{
            titleOutlet.text = ""
            textOutlet.attributedText = NSAttributedString(string: "", attributes: attribute)
        }else{
            let note = context.object(with: objectID!) as! NoteData
            titleOutlet.text = note.title
            textOutlet.attributedText = NSAttributedString(string: note.content!, attributes: attribute)
        }
        
        titleOutlet.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        textOutlet.font = UIFont.systemFont(ofSize: 20, weight: .light)
        textOutlet.becomeFirstResponder()
    }
    
    func saveNote(){
        if newNote{
            if textOutlet.text != "" || titleOutlet.text != ""{
                let note = NoteData(context: self.context)
            
                note.title = titleOutlet.text == "" ? "Note" : titleOutlet.text
                note.content = textOutlet.text
                note.author = username
                note.createdAt = Date()
                do{
                    try context.save()
                    print("save succeeded")
                } catch{
                    print ("save failed")
                }
            }
        }
        else{
            let note = context.object(with: objectID!) 
            note.setValue(titleOutlet.text, forKey: "title")
            note.setValue(textOutlet.text, forKey: "content")
            do{
                try context.save()
            }
            catch{
                print(error)
            }
        }
    }
    
    @IBAction func deleteNoteAction(_ sender: UIBarButtonItem) {
        let note = context.object(with: objectID!)
        context.delete(note)
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}
