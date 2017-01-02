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
    
    // MARK: - Variables
    var SelectedRoomID: String = ""
    var Messages: [[String:Any]] = [[String:Any]]()
    var dataSource: tableDataSource!

    // MARK: - View Controller Events
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Custom Cell
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        // Table Data Source
        dataSource = tableDataSource(ParentVC: self, cellIdentifier: "cell")
        tableView.dataSource = dataSource

        
        setupListeners()
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    func setupListeners() {
        let helper = FirebaseHelper.Database()
        helper.Query(path: "Chat/Messages/", orderBy: "ROOM", condition: .equalToString(SelectedRoomID), observingMode: .listenForChanges, eventType: .childAdded) { (snapshot) in
            
            self.Messages.append(snapshot as! [String : Any])
            
            self.tableView.insertRows(at: [IndexPath(row: self.Messages.count-1, section: 0)], with: .automatic)

        }
        
        return
        
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
            // Get Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            
            // Set text
             cell.textLabel?.text = parent.Messages[indexPath.row]["Sender"] as! String?
             cell.detailTextLabel?.text = parent.Messages[indexPath.row]["Body"] as! String?
            // cell.textLabel?.text = "adas"
            // cell.detailTextLabel?.text = "bb999"
            // Return
            return cell
        }
    }
}
