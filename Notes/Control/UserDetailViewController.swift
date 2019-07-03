//
//  UserDetailViewController.swift
//  Notes
//
//  Created by Ridwan Abdurrasyid on 02/07/19.
//  Copyright © 2019 Mentimun Mulus. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var userDetailViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailViewOutlet.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
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
