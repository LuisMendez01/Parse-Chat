//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Luis Mendez on 10/3/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /***********************
     * IBACTIONS FUNCTIONS *
     ***********************/
    @IBAction func loginAction(_ sender: Any) {
            
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
    
            //ActionSheet
            let alertController = UIAlertController(title: "LogIn", message: "Make sure username & password are correct", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                // handle case of user canceling. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alert controller
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        } else {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    //ActionSheet
                    let alertController2 = UIAlertController(title: "Error", message: "User log in failed: \(error.localizedDescription)", preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                        // handle case of user canceling. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alert controller
                    alertController2.addAction(cancelAction)
                    
                    self.present(alertController2, animated: true){
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                    print("User log in failed: \(error.localizedDescription)")
                } else {
                    print("User logged in successfully")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        // manually segue to logged in view
                        self.performSegue(withIdentifier: "toChatSegue", sender: nil)
                    }
                }
            }
        }//else
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        // initialize a user object
        let newUser = PFUser()
            
        // set user properties
        newUser.username = usernameTextField.text
        //newUser.email = emailField.text
        newUser.password = passwordTextField.text
        
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
                
            //Alert
            let alertController = UIAlertController(title: "Alert", message: "Both fields need to be entered", preferredStyle: .alert)
                
            // create a cancel action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)

        }
        else {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    //Alert
                    let alertController2 = UIAlertController(title: "Error", message:error.localizedDescription, preferredStyle: .actionSheet)
                        
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        // handle case of user canceling. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alert controller
                    alertController2.addAction(cancelAction)
                    self.present(alertController2, animated: true){
                            MBProgressHUD.hide(for: self.view, animated: true)
                    }
                        
                    print(error.localizedDescription)
                } else {
                    print("User Registered successfully")
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        // manually segue to logged in view
                        self.performSegue(withIdentifier: "toChatSegue", sender: nil)
                    }
                }
            }
        }//else
    }
}

//ActionSheet
/*
let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
    // handle case of user logging out
}
// add the logout action to the alert controller
alertController.addAction(logoutAction)
 
 present(alertController, animated: true) {
 // optional code for what happens after the alert controller has finished presenting
 }
*/


/*
 // create an OK action Alert
 let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
 // handle response here.
 }
 // add the OK action to the alert controller
 alertController.addAction(OKAction)
 
 present(alertController, animated: true) {
 // optional code for what happens after the alert controller has finished presenting
 }
 */
/*NOTE: If you wish to call present() outside a view controller, you would do:
 //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true) {
 // optional code for what happens after the alert controller has finished presenting
 }*/
