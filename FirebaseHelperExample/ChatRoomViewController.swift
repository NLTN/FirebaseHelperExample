//
//  ChatRoomViewController.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/31/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import FirebaseHelper

class ChatRoomViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var chatRooms: [String:Any] = [String:Any]()
     var dataSource: tableDataSource!

    // MARK: - View Contoller's Events
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table Data Source
        dataSource = tableDataSource(ParentVC: self, cellIdentifier: "cell")
        tableView.dataSource = dataSource
        
        // Firebase Listeners
        setupListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "segueChatRoomDetail"  {
            if let destController = segue.destination as? ChatRoomDetailViewController {
                if let selectedRow = tableView.indexPathForSelectedRow?.row {
                    destController.SelectedRoomID = chatRooms[selectedRow].key
                }
            }
        }
     }
    
    // MARK: Functions
    func setupListeners() {
        let commentsRef = FirebaseHelper.Database().getReference()
        
        // Listen for new comments in the Firebase database
        commentsRef.child("Chat/Rooms").queryOrdered(byChild: "SortOrder").observe(.value, with: { (snapshot) -> Void in
            if !snapshot.exists() {
                return
            }
            
            self.chatRooms = snapshot.value as! [String : Any]
            
            // Reload the table
             self.tableView.reloadData()
        })
    }
}

extension ChatRoomViewController {
    class tableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
        
        // Cell reuse identifier
        var cellIdentifier: String
        
        // ParentViewControler
        var parent: ChatRoomViewController
        
        // Constructor
        init(ParentVC: ChatRoomViewController, cellIdentifier: String!) {
            parent = ParentVC
            self.cellIdentifier = cellIdentifier
            
            super.init()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.chatRooms.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Get Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            
            // Set text
            cell.textLabel?.text = parent.chatRooms[indexPath.row].key
            cell.detailTextLabel?.text = (parent.chatRooms[indexPath.row].value as! [String: Any])["Name"] as! String?
            
            // Return
            return cell
        }
    }
}
