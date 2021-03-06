//
//  ChatRoomDetailViewController.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 1/1/17.
//  Copyright © 2017 Nguyen Nguyen. All rights reserved.
//

import UIKit
import FirebaseHelper

class ChatRoomDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtMessageBody: UITextField!
    
    // MARK: - Variables
    var SelectedRoomID: String = ""
    var Messages: [[String:Any]] = [[String:Any]]()
    var dataSource: tableDataSource!

    // MARK: - View Controller Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Notification
        registerForKeyboardNotifications()

        // Setup Table Data Source
        dataSource = tableDataSource(ParentVC: self, cellIdentifier: "cell")
        tableView.dataSource = dataSource

        // Setup TableView
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 340
        
        // Firebase
        setupListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unregister for Notifications
        unregisterForNotifications()
    }
    
    // KeyboarWillShow
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            self.handleKeyboardWillShowOrHide(up: true, keyboardHeight: (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height)
        }
    }
    
    // KeyboarWillHide
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            self.handleKeyboardWillShowOrHide(up: false, keyboardHeight: (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func btnSendAction(_ sender: UIButton) {
        if !(txtMessageBody.text?.isEmpty)! {
            // Get Current User
            let user = FirebaseHelper.Authentication.currentUser
            
            var displayName = ""
            if user?.displayName != nil {
                displayName = (user?.displayName)!
            } else {
                displayName = (user?.email)!
            }
            
            // Send
            sendMessage(withUserID: user!.uid, username: displayName, title: "abc", body: txtMessageBody.text!)
            
            // Clear the text field
            txtMessageBody.text = ""
            
            // Hide keyboard
            txtMessageBody.resignFirstResponder()
        }
    }
    
    // MARK: - Functions
    var enableScrollDown = false
    func ScrollDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             self.tableView.scrollToRow(at: IndexPath(row: self.Messages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func setupListeners() {
        let helper = FirebaseHelper.Database()
        helper.Query(path: "/Chat/Messages/", orderBy: "RoomID", condition: .equalToString(SelectedRoomID), observingMode: .listenForChanges, eventType: .childAdded) { (snapshot) in
            
            // Append to the array
            self.Messages.append(snapshot as! [String : Any])
            
            // Insert table row
            self.tableView.insertRows(at: [IndexPath(row: self.Messages.count-1, section: 0)], with: .automatic)

            // Scroll down
            // if self.enableScrollDown {
                self.ScrollDown()
            // }
            
        }
    }
    
    func sendMessage(withUserID userID: String, username: String, title: String, body: String) {
        let ref = FirebaseHelper.Database().getReference()
        
        let key = ref.child("/Chat/Messages/").childByAutoId().key
        let post = ["SenderID": userID,
                    "SenderName": username,
                    "RoomID": SelectedRoomID,
                    "Body": body]
        let childUpdates = ["/Chat/Messages/\(key)": post]
        ref.updateChildValues(childUpdates)
        
        enableScrollDown = true

    }
    
    // MARK: - Private Functions - Keyboard
    func registerForKeyboardNotifications() {
        // Listen for Keyboard Will Show Event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // Listen for Keyboard Will Hide Event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShowOrHide(up: Bool, keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            let bottomBarHeight = self.tabBarController?.tabBar.frame.height
            let movement = (up ? -keyboardHeight+bottomBarHeight! : keyboardHeight-bottomBarHeight!)
            
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            self.view.layoutIfNeeded()
        })
    }
}

extension ChatRoomDetailViewController {
    class tableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
        
        // Cell reuse identifier
        var cellIdentifier: String
        
        // ParentViewControler
        var parent: ChatRoomDetailViewController
        
        // Constructor
        init(ParentVC: ChatRoomDetailViewController, cellIdentifier: String!) {
            parent = ParentVC
            self.cellIdentifier = cellIdentifier
            
            super.init()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.Messages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if parent.Messages[indexPath.row]["SenderID"] as! String? == FirebaseHelper.Authentication.currentUser?.uid {
                // Get Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyMessage", for: indexPath) as! MyMessageCell
                
                // Set Text
                cell.lblBody.text = parent.Messages[indexPath.row]["Body"] as! String?
                
                // Return
                return cell
            } else {
                // Get Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellMessage", for: indexPath) as! MessageCell
                
                // Set text
                cell.lblSender.text = parent.Messages[indexPath.row]["SenderName"] as! String?
                cell.lblBody.text = parent.Messages[indexPath.row]["Body"] as! String?
                
                // Return
                return cell
            }
            
        }
    }
}
