//
//  FirstViewController.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/22/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import FirebaseHelper

class FirstViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var lblDisplayTextFromFirebase: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        testObserveEvent()
    
        FirebaseHelper.Authentication.addStateDidChangeAction("FirstViewController", self.testObserveEvent)
        
        // testQuery()
        // testQueryByString()
        testQueryByNumber()
    }
    
    func testObserveEvent() {
        if FirebaseHelper.Authentication.IsSignedIn {
            let ref = FirebaseHelper.Database().getReference()
            
            ref.child("MinhYen-aNpg4udZeac0lN5ArA68Ro2uj572/Users/User-01/").observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                self.lblDisplayTextFromFirebase.text = value?["Theme"] as? String ?? "Unknown"
            })
        } else {
            self.lblDisplayTextFromFirebase.text = "Empty"
        }
    }
    
    func testQueryByNumber() {
        let helper = FirebaseHelper.Database()

        helper.Query(path: "MinhYen-aNpg4udZeac0lN5ArA68Ro2uj572/Users/", orderBy: "YearOfBirth", condition: .between(1984, 1988), observingMode: .listenForChanges, eventType: .value) { (snapshot) in
            
            if snapshot == nil {
                return
            }
            
            print(">>----------------------------")
            for item in snapshot! {
                let itemValue = item.value as! [String: Any]
                print(">>TENG TENG: \(itemValue["Name"])")
            }
        }
    }
    
    func testQueryByString() {
        let helper = FirebaseHelper.Database()
        
        helper.Query(path: "MinhYen-aNpg4udZeac0lN5ArA68Ro2uj572/Users/", orderBy: "Theme", condition: .equalToString("Blue"), observingMode: .readDataOnce, eventType: .value) { (snapshot) in
           
            if snapshot == nil {
                return
            }
            
            for item in snapshot! {
                let itemValue = item.value as! [String: Any]
                print(">>TENG TENG: \(itemValue["Name"])")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Events
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        // FirebaseHelper.Authentication.CreateUser(withEmail: "nltn@msn.com", password: "abc123")
        FirebaseHelper.Authentication.CreateUser(withEmail: "nltn@msn.com", password: "123abc") { (userID:String?, error) in
            if error != nil {
                print(error!)
                return
            } else {
                print("User is registered. UID:\(userID)")
            }
            
            
        }
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
         FirebaseHelper.Authentication.SignIn(withEmail: "nltn@msn.com", password: "123abc")
    }
    @IBAction func btnSignOut(_ sender: UIButton) {
        FirebaseHelper.Authentication.SignOut()
    }
    
    @IBAction func btnCheckForSignedInStatus(_ sender: UIButton) {
        print("Is Signed In: \(FirebaseHelper.Authentication.IsSignedIn)")
    }
}

