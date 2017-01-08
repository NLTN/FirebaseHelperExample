//
//  SecondViewController.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/22/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import FirebaseHelper

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         // let remoteConfig = FirebaseHelper.RemoteConfig()
         // remoteConfig.fetchConfig()
        
        let i = DataStructure(title: "Go to school", user: "User-01", completed: false)
        
        print("To Dict:")
        print(i.toDictionary())
        print("------------------------")
        print("To JSON:")
        //print(i.toJSON())
        print("------------------------")
        print("To JSON 2:")
        print(i.toJSON2())
        
        Test()
    }

    func Test() {
        let a = FirebaseHelper.Storage()
        // a.TestUpload()
        
        
        let DocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        let filePath = DocumentDirectory + "/MYSale.db.zip"
        a.Upload(filePath: filePath, storagePath: "") { (percentComplete, metadata, error) in
            if error != nil {
                print(error!)
            } else {
                if percentComplete == 100 {
                    print("Success.")
                    print("Download URL: \(metadata?.downloadURL())")
                } else {
                    print("percent:\(percentComplete), url:\(metadata?.downloadURL())")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Actions
    
    @IBAction func btnSignOutAction(_ sender: UIButton) {
        FirebaseHelper.Authentication.SignOut()
    }
}

