//
//  Chats.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 18/10/2021.
//

import UIKit


class Chats: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var people: [Person]?
    var personEntity = PersonEntity()
    var selectedChat = 0
    
    @IBOutlet var chatsTableView: UITableView!
    
    @IBAction func unwindToChats(segue: UIStoryboardSegue) {
        self.people = self.personEntity.fetch(tableView: self.tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMessages" {
            let vc = segue.destination as! Messages
            vc.selectedChat = self.selectedChat
        }
    }
    
    // MARK: TableView Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChat = indexPath.row
        performSegue(withIdentifier: "showMessages", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people != nil ? people!.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = chatsTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        let person = self.people![indexPath.row]
        
        chatCell.avatar.text = String(person.firstName!.prefix(1)) + String(person.familyName!.prefix(1))
        chatCell.avatar.layer.cornerRadius = 32.0
        chatCell.name.text = person.firstName
        chatCell.number.text = person.number
        
        return chatCell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, complettionHandler) in
            
            let personToRemove = self.people![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do {
                try self.context.save()
            } catch {
                
            }
            
            self.people = self.personEntity.fetch(tableView: self.tableView)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.people = self.personEntity.fetch(tableView: self.tableView)
        
    }
}
