//
//  UserLoginViewController.swift
//  Notes
//
//  Created by Ridwan Abdurrasyid on 02/07/19.
//  Copyright © 2019 Mentimun Mulus. All rights reserved.
//

import UIKit
import CoreData

class UserLoginViewController: UIViewController {

    @IBOutlet weak var loginViewOutlet: UIView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var logoutViewOutlet: UIView!
    @IBOutlet weak var usernameTextOutlet: UITextField!
    @IBOutlet weak var passwordTextOutlet: UITextField!
    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var loginStatusOutlet: UILabel!
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var username : String?
    var keyboardCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewOutlet.layer.cornerRadius = 15
        loginButtonOutlet.layer.cornerRadius = 5
        logoutViewOutlet.layer.cornerRadius = 15
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        loginStatusOutlet.text = ""
        loadLastUser()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        passwordTextOutlet.resignFirstResponder()
        usernameTextOutlet.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(){
        if !keyboardCalled{
            keyboardCalled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.loginViewOutlet.transform = CGAffineTransform(translationX: 0, y: -100)
                self.logoutViewOutlet.transform = CGAffineTransform(translationX: 0, y: -100)
            })
        }
    }
    
    @objc func keyboardWillDisappear(){
        if keyboardCalled{
            keyboardCalled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.loginViewOutlet.transform = CGAffineTransform(translationX: 0, y: 0)
                self.logoutViewOutlet.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    func loadLastUser(){
        let isLoggedIn =  defaults.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            loginHide()
            username = defaults.string(forKey: "lastUsername")
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
            
            request.predicate = NSPredicate(format: "username == %@", username!)
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(request) as! [UserData]
                if let userData = result.first {
                    nameLabelOutlet.text = "Hi, \(userData.name!)"
                }
            } catch {
                print("fetching failed")
            }
        }else {
            loginShow()
        }
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        let username = usernameTextOutlet.text
        let password = passwordTextOutlet.text
        
        if username != "" && password != ""{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
            
            request.predicate = NSPredicate(format: "username == %@ AND password == %@", username!, password!)
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(request) as! [UserData]
                if let userData = result.first {
                    defaults.set(true, forKey: "isLoggedIn")
                    defaults.set(userData.username, forKey: "lastUsername")
                    nameLabelOutlet.text = "Hi, \(userData.name!)"
                    loginStatusOutlet.text = "Login Success"
                    loginStatusOutlet.textColor = .green
                    loginHide()
                }else{
                    loginStatusOutlet.text = "Login Failed"
                    loginStatusOutlet.textColor = .red
                }
            } catch {
                print("fetching failed")
            }
        }
    }
    

    @IBAction func logoutButtonAction(_ sender: UIButton) {
        defaults.set(false, forKey: "isLoggedIn")
        loginStatusOutlet.text = ""
        loginShow()
    }
    
    func loginShow(){
        logoutViewOutlet.isHidden = true
        loginViewOutlet.isHidden = false
    }
    
    func loginHide(){
        logoutViewOutlet.isHidden = false
        loginViewOutlet.isHidden = true
    }
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
