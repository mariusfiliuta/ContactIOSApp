//
//  contact.swift
//  Contact
//
//  Created by intern on 13/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit

enum contactValidatingErrors{
    case emptyString
    case wrongNumberFormat
    case wrongEmailFormat
    case invalidGroup
    case valid
}

class Contact: NSObject, NSCoding{
    // MARK: Categories
    static let contactGroups = ["None", "Family", "Friends", "Work"]
    // MARK: Properties
    var firstName: String
    var secondName: String
    var number: String
    var mail: String
    var photo: UIImage?
    var group: String = "None"
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.URLByAppendingPathComponent("contactsBigBit")
    
    // MAKR: Types
    struct PropertyKey{
        static let firstName = "firstName"
        static let secondName = "secondName"
        static let number = "number"
        static let mail = "mail"
        static let photo = "image"
        static let group = "group"
        
    }
    init?(firstName: String, secondName: String, number: String, mail: String, photo: UIImage?, group: String = "None"){
        self.firstName = firstName
        self.secondName = secondName
        self.number = number
        self.mail = mail
        self.photo = photo
        self.group = group
        
        super.init()
        
        // Initialization Fails
        if Contact.checkValidContact(firstName, secondName: secondName, number: number, mail: mail, group: group).isEmpty == false {
            return nil
        }
        
    }
    func compareFullName(b: Contact) -> Bool{
        let fullName0 = self.firstName + " " + self.secondName
        let fullName1 = b.firstName + " " + b.secondName
        
        return fullName0 < fullName1
    }
    static func checkValidContact(firstName: String?, secondName: String?, number: String?, mail: String?, group: String) -> [contactValidatingErrors]{
        var errors = [contactValidatingErrors]()
        if firstName!.isEmpty || secondName!.isEmpty || number!.isEmpty || mail!.isEmpty {
            errors.append(.emptyString)
        }
    
        //let numberRegEx = "[0-9]"
        //let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numb = Int(number!)
        if numb == nil{
             errors.append(.wrongNumberFormat)
        }
    
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    
        if !emailTest.evaluateWithObject(mail) {
             errors.append(.wrongEmailFormat)
        }
        
        if !contactGroups.contains(group) {
            errors.append(.invalidGroup)
        }
        return errors
    }
    
    func getFullName() -> String{
        return self.firstName + " " + self.secondName
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstName)
        aCoder.encodeObject(secondName, forKey: PropertyKey.secondName)
        aCoder.encodeObject(number, forKey: PropertyKey.number)
        aCoder.encodeObject(mail, forKey: PropertyKey.mail)
        aCoder.encodeObject(photo, forKey: PropertyKey.photo)
        aCoder.encodeObject(group, forKey: PropertyKey.group)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObjectForKey(PropertyKey.firstName) as! String
        let secondName = aDecoder.decodeObjectForKey(PropertyKey.secondName) as! String
        let number = aDecoder.decodeObjectForKey(PropertyKey.number) as! String
        let mail = aDecoder.decodeObjectForKey(PropertyKey.mail) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photo) as? UIImage
        let group = aDecoder.decodeObjectForKey(PropertyKey.group) as! String
        self.init( firstName: firstName, secondName: secondName, number: number, mail: mail, photo: photo, group: group)
    }
}
