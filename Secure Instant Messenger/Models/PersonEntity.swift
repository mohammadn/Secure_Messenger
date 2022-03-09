//
//  PersonEntityController.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 30/12/2021.
//

import Foundation
import UIKit

class PersonEntity {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // fetch all data
    func fetch(tableView: UITableView) -> [Person] {
        
        var people: [Person]?
        
        do {
            
            people = try context.fetch(Person.fetchRequest()).reversed()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        } catch {
            print("Error : Can't fetch People's Data")
        }
        
        return people!
    }
    
    // Save a new person
    func saveNewPerson(firstName: String, familyName: String, number: String) {
        
        let newPerson = Person(context: self.context)
        
        newPerson.firstName = firstName
        newPerson.familyName = familyName
        newPerson.number = number
        
        do {
            
            try self.context.save()
            
        } catch {
            print("Error: Can't save the person")
        }
        
    }
    
    // finding a row with a specific number
    func findNum(number: String) -> Person {
        
        let request = Person.fetchRequest()
        let predict = NSPredicate(format: "number == %@", number)
        request.predicate = predict
        
        return try! context.fetch(request)[0]
    }
}
