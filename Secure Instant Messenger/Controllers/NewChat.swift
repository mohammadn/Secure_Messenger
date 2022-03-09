//
//  NewChat.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 25/10/2021.
//

import Foundation
import UIKit

class NewChat: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var personEntity = PersonEntity()
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var familyName: UITextField!
    @IBOutlet var number: UITextField!
    @IBOutlet var errorMessage: UILabel!
    
    @IBAction func createNewChat(_ sender: Any) {
        
        if self.firstName.text != "" &&
            self.familyName.text != "" &&
            self.number.text != "" {
            
            self.personEntity.saveNewPerson(firstName: self.firstName.text!, familyName: self.familyName.text!, number: self.number.text!)
            
            performSegue(withIdentifier: "showChats", sender: self)
            
        } else {
            errorMessage.text = "Please fill in all the fields"
        }
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
