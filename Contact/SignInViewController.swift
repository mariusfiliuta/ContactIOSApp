//
//  SignInViewController.swift
//  Contact
//
//  Created by intern on 22/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, GIDSignInUIDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Always disconnect the last connection if any
        GIDSignIn.sharedInstance().signOut()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var singInButton: GIDSignInButton!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
        
        print("Sign in presented")
        
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        print("Sign in dismissed")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        storyBoard.instantiateInitialViewController()
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ContactTableViewController") as! ContactTableViewController
        let navigationController =  UINavigationController(rootViewController: nextViewController)
        self.presentViewController(navigationController, animated:true, completion:nil)
    }

}
