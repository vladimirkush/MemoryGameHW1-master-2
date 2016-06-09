//
//  MainMenuController.swift
//  MemoryGameHW1
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SVTeam. All rights reserved.
//



import UIKit

class MainMenuController: UIViewController {
    
    
    @IBOutlet weak var nameLable: UITextField! 
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    let currentUserKey = "currentUser"
    
    
    @IBAction func newGamePressed(sender: AnyObject) {
        print("Name \(nameLable.text)")
        
        //insert the name into shared preferences
       
        preferences.setObject(nameLable.text, forKey: currentUserKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        if preferences.objectForKey(currentUserKey) == nil {
            //  Doesn't exist
            nameLable.text="Insert Name Here"
        } else {
            
            nameLable.text=preferences.stringForKey(currentUserKey)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
       /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
