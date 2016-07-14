//
//  ContactTableViewController.swift
//  Contact
//
//  Created by intern on 13/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    // MARK: Properties
    var contacts = [Contact]()
    let searcController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Add contacts from local files if any; sort contacts
        if let savedContacts = loadContacts() {
            contacts += savedContacts
        }
        
        contacts.sortInPlace({
            $0.compareFullName($1)
        })
        
        // Add Search Controller
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        let contact = contacts[indexPath.row]
        
        cell.photo.image = contact.photo
        cell.fullName.text = contact.firstName + " " + contact.secondName

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            contacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            contacts.sortInPlace({
                $0.compareFullName($1)
            })
            saveContacts()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let contactViewController = segue.destinationViewController as! ContactViewController
            
            if let selectedContactCell = sender as? ContactTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedContactCell)!
                let selectedContact = contacts[indexPath.row]
                contactViewController.contact = selectedContact
            }
            
        }else if segue.identifier == "AddItem"{
            
        }
    }
    
    
    @IBAction func unwindToContactList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? ContactViewController, contact = sourceViewController.contact {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update
                contacts[selectedIndexPath.row] = contact
                contacts.sortInPlace({
                    $0.compareFullName($1)
                })
                //tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Bottom)
                tableView.reloadData()
            }
            else{
                // Add
                //let newIndexPath = NSIndexPath(forRow: contacts.count, inSection: 0)
                contacts.append(contact)
                contacts.sortInPlace({
                    $0.compareFullName($1)
                })
                //tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                tableView.reloadData()
            }
            saveContacts()
        }
    }
 
    // MARK: NSCoding
    func saveContacts(){
        let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(contacts, toFile: Contact.ArchiveUrl.path!)
        
        if !isSuccesfulSave {
            print("Fail to save contacts")
        }
    }
    func loadContacts() -> [Contact]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Contact.ArchiveUrl.path!) as? [Contact]
    }

}
