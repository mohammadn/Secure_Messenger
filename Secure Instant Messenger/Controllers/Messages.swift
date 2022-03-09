//
//  Messages.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 25/10/2021.
//

import Foundation
import UIKit

class Messages: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var people: [Person]?
    var personEntity = PersonEntity()
    var messages: [Message]?
    var messageEntity = MessageEntity()
    var selectedChat = 0
    var selectedMessage : Message?
    var cryptogaphy = Cryptography()
    
    @IBOutlet var messagesTableView: UITableView!
    @IBOutlet var message: UITextField!
    
    // Passing the value to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMessageDetails" {
            let vc = segue.destination as! MessageDetails
            vc.selectedMessage = self.selectedMessage
        }
        
    }
    
    // MARK: Encrypting and Save Message to Core Data
    @IBAction func encrypt(_ sender: Any) {
        
        if self.message.text != "" {

            // Encryption
            let (ciphertext, key) = cryptogaphy.encryption(message: self.message.text!)

            // Save the message
            self.messageEntity.saveNewMessage(message: self.message.text!, key: key, ciphertext: ciphertext, person: people![self.selectedChat])
            
            // Refresh the page
            self.message.text = ""
            self.messages = self.messageEntity.fetch(tableView: self.messagesTableView, person: self.people![self.selectedChat])
            
        }
        
    }
    
    // MARK: Moving Textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        moveTextField(textField, moveDistance: -330, up: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        moveTextField(textField, moveDistance: -330, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)

        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMessage = self.messages![indexPath.row]
        performSegue(withIdentifier: "showMessageDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages != nil ? messages!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        messageCell.message.text = self.messages![indexPath.row].message
        messageCell.ciphertext.text = self.messages![indexPath.row].ciphertext
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complettionHandler) in
            
            let messageToRemove = self.messages![indexPath.row]
            
            self.context.delete(messageToRemove)
            
            do {
                try self.context.save()
            } catch {
                
            }
            
            self.messages = self.messageEntity.fetch(tableView: self.messagesTableView, person: self.people![self.selectedChat])
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        self.people = self.personEntity.fetch(tableView: self.messagesTableView)
        self.messages = self.messageEntity.fetch(tableView: self.messagesTableView, person: self.people![self.selectedChat])
        
        navigationItem.title = people![self.selectedChat].firstName
        
    }

}
