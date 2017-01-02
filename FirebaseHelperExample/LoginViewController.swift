//
//  LoginViewController.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/28/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import UIKit
import FirebaseHelper

class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var segLoginOrRegister: UISegmentedControl!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    
    // MARK: - Constructors
    // Load uiview from nib file
    class func instanceFromNib() -> LoginViewController {
        //return UINib(nibName: "LoginViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoginViewController
        
        return LoginViewController(nibName: "LoginViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         registerForKeyboardNotifications()
        
        // Set Button Title
        btnGo.setTitle(segLoginOrRegister.titleForSegment(at: segLoginOrRegister.selectedSegmentIndex), for: .normal)
        
    }
    
    // Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Events
    // KeyboarWillShow
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            self.handleKeyboardWillShowOrHide(up: true, keyboardHeight: (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height)
        }
    }
    
    // KeyboarWillHide
    func keyboardWillHide(_ sender: Notification) {
        self.handleKeyboardWillShowOrHide(up: false, keyboardHeight: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBOutlet Actions
    @IBAction func btnGoAction(_ sender: UIButton) {
        
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        //return
            
        FirebaseHelper.Authentication.SignIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            
            //alert.dismiss(animated: true, completion: nil)
            if error != nil {
                print(error!)
                self.showAlert(title: nil, message: "Invalid username or password")
                
            } else {
                self.GoToMainStoryboard()
            }            
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    @IBAction func segLoginOrRegisterAction(_ sender: UISegmentedControl) {
        // Set button title
        btnGo.setTitle(sender.titleForSegment(at: sender.selectedSegmentIndex), for: .normal)
    }
    
    // MARK: - Private Functions - Keyboard
    func registerForKeyboardNotifications() {
        // Listen for Keyboard Will Show Event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // Listen for Keyboard Will Hide Event
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShowOrHide(up: Bool, keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.viewForm.frame.origin.y = (up ? (UIScreen.main.bounds.height - keyboardHeight - self.viewForm.frame.height)/2 : (UIScreen.main.bounds.height - self.viewForm.frame.height)/4)
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Private Functions - Form Controls
    func handleSegmentControl() {
        
    }
    
    func GoToMainStoryboard(){
        // Create a storyboard instance.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Set rootView
        UIApplication.shared.delegate?.window??.rootViewController = storyboard.instantiateInitialViewController()
    }
}
