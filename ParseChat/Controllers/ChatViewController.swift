//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Luis Mendez on 10/3/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import Alamofire

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var MessageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var chatMessages: [PFObject] = []
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Remove table view row outlines in viewDidLoad()
        tableView.separatorStyle = .none
        
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableView.automaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        
        //calls this ontimer() every 1 second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        //Set title button logOut
        setRightBtnLogOut()
        
        //af_setImage(withURL:)
    }
    
    func setRightBtnLogOut(){
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(logOut), for: UIControl.Event.touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    /***********************
     * @OBJC FUNCTIONS *
     ***********************/
    @objc func logOut() {
        
        // Logout the current user
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                print("Successful loggout")
            }})
        
        //Grab a reference to the presenting VC
        let thePresenter = self.presentingViewController
        //if NavBar presented it
        //let thePresenter = self.navigationController.viewControllers.objectAtIndex:self.navigationController.viewControllers.count - 2
        
        if thePresenter is LoginViewController {
            print("Dismiss performed segue from LoginVC logout right here and then dismiss")
            
            //dismiss if coming from segue from LoginVC,
            //if coming from rootVC in delegate for persisted user then this won't do anything
            dismiss(animated: true, completion: nil)
        } else {
            print("Loggin out from NotificationCenter in Delegate to return to main controller")
            
            // Notify user was logged out and changed main VC to LoginVC
            NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
        }
    }
    
    @objc func onTimer() {
        
        // construct query
        let query : PFQuery = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground(block: { (incomingPosts, error) in
            if let incomingPosts = incomingPosts {
                
                for post in incomingPosts {
                        print(post)
                }
                
                // do something with the array of object returned by the call
                self.chatMessages = incomingPosts
                print(incomingPosts)
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    @IBAction func sendMessageAction(_ sender: Any) {
        
        //1. create a new Message of type PFObject and save it to Parse, case sensitive
        let chatMessage = PFObject(className: "Message")
        
        //2. Store the text of the text field in a key called text. (Provide a default empty string so message text is never nil)
        chatMessage["text"] = MessageTextField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        //3. Call saveInBackground(block:) and print when the message successfully saves or any errors.
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                
                //4. On successful message save, clear the text from the text chat field.
                self.MessageTextField.text = ""
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    /***********************
     * TABLEVIEW FUNCTIONS *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Que!: \(chatMessages.count)")
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath as IndexPath) as! ChatViewCell
        
        if let user = chatMessages[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        cell.messageTextLabel.text = (chatMessages[indexPath.row]["text"] as! String)
        
        return cell
    }
}
