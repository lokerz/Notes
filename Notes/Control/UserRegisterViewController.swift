//
//  UserRegisterViewController.swift
//  Notes
//
//  Created by Ridwan Abdurrasyid on 02/07/19.
//  Copyright © 2019 Mentimun Mulus. All rights reserved.
//

import UIKit
import CoreData

class UserRegisterViewController: UIViewController {
    @IBOutlet weak var signupViewOutlet: UIView!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    var keyboardCalled = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        signupViewOutlet.layer.cornerRadius = 15
        signupButtonOutlet.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signupButtonOutlet.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(){
        if !keyboardCalled{
            keyboardCalled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.signupViewOutlet.transform = CGAffineTransform(translationX: 0, y: -100)
            })
        }
    }
    
    @objc func keyboardWillDisappear(){
        if keyboardCalled{
            keyboardCalled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.signupViewOutlet.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    @IBAction func confirmPasswordAction(_ sender: Any) {
        if confirmField.text == passwordField.text && confirmField.text != "" {
            signupButtonOutlet.isHidden = false
        }
    }
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        guard let name = nameField.text else {
            return
        }
        guard let username = usernameField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        let user = UserData(context: self.context)
        user.name = name
        user.username = username
        user.password = password
        do{
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch{
            print ("save failed")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
