//
//  ReceiveMessage.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 18/10/2021.
//

import UIKit

class ReceiveMessage: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var person: Person?
    var personEntity = PersonEntity()
    var messageEntity = MessageEntity()
    var cryptography = Cryptography()
        
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var ciphertext: UITextField!
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var decryptedText: UILabel!
    
    @IBAction func decrypt(_ sender: Any) {
        
        // check if there isn't any input show an error
        if self.ciphertext.text != "" &&
            self.key.text != "" {
            
            // Decryption
            let message = cryptography.decryption(ciphertext: self.ciphertext.text!, key: self.key.text!)
            
            // Printing the message on screen
            decryptedText.text = message
            self.decryptedText.textColor = UIColor.black
            
            // Save the message if user entered the number
            if self.number.text != "" {
                
                // Find the person by number
                self.person = self.personEntity.findNum(number: self.number.text!)
                
                // If there isn't any person show an error
                if self.person != nil {

                    self.messageEntity.saveNewMessage(message: message, key: self.key.text!, ciphertext: self.ciphertext.text!, person: self.person!)
                    
                } else {
                    
                    let alert = UIAlertController(title: "No Chat", message: "There isn't any chat with this phone number.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    
                }
                
            }
            
        } else {
            
            self.decryptedText.text = "Please fill in Ciphertext and Key fields"
            self.decryptedText.textColor = UIColor.systemRed
            
        }
        
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
}
