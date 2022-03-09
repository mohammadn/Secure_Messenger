//
//  MessageEntityController.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 30/12/2021.
//

import Foundation
import UIKit

class MessageEntity {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // fetching all data
    func fetch(tableView: UITableView, person: Person) -> [Message] {
        
        var messages: [Message]?
        
        do {
            
            let request = Message.fetchRequest()
            let predict = NSPredicate(format: "number == %@", person)
            request.predicate = predict
            messages = try context.fetch(request)
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        } catch {
            print("Error : Can't fetch Messages' Data")
        }
    
        return messages!
    }
    
    // Save a new person
    func saveNewMessage(message: String, key: String, ciphertext: String, person: Person) {

        let newMessage = Message(context: self.context)
        
        newMessage.message = message
        newMessage.key = key
        newMessage.ciphertext = ciphertext
        newMessage.number = person

        do {
            
            try self.context.save()
            
        } catch {
            print("Error: Can't save the message")
        }
        
    }

}
