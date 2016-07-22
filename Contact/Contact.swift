//
//  contact.swift
//  Contact
//
//  Created by intern on 13/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit
import MapKit

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
    var location: MKPointAnnotation?
    
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
        static let latitude = "latitude"
        static let longitude = "longitude"
        
    }
    init?(firstName: String, secondName: String, number: String, mail: String, photo: UIImage?, group: String = "None", location: MKPointAnnotation?){
        self.firstName = firstName
        self.secondName = secondName
        self.number = number
        self.mail = mail
        self.photo = photo
        self.group = group
        self.location = location
        
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
        // MARK: Token
        let clientId =  GIDSignIn.sharedInstance().currentUser?.authentication.clientID ?? ""
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstName + clientId)
        aCoder.encodeObject(secondName, forKey: PropertyKey.secondName + clientId)
        aCoder.encodeObject(number, forKey: PropertyKey.number + clientId)
        aCoder.encodeObject(mail, forKey: PropertyKey.mail + clientId)
        aCoder.encodeObject(photo, forKey: PropertyKey.photo + clientId)
        aCoder.encodeObject(group, forKey: PropertyKey.group + clientId)
        aCoder.encodeObject(location?.coordinate.latitude, forKey: PropertyKey.latitude + clientId)
        aCoder.encodeObject(location?.coordinate.longitude, forKey: PropertyKey.longitude + clientId)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // MARK: Token
        let clientId =  GIDSignIn.sharedInstance().currentUser?.authentication.clientID ?? ""
        let firstName = aDecoder.decodeObjectForKey(PropertyKey.firstName + clientId) as! String
        let secondName = aDecoder.decodeObjectForKey(PropertyKey.secondName + clientId) as! String
        let number = aDecoder.decodeObjectForKey(PropertyKey.number + clientId) as! String
        let mail = aDecoder.decodeObjectForKey(PropertyKey.mail + clientId) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photo + clientId) as? UIImage
        let group = aDecoder.decodeObjectForKey(PropertyKey.group + clientId) as! String
        let latitude = aDecoder.decodeObjectForKey(PropertyKey.latitude + clientId) as? CLLocationDegrees
        let longitude = aDecoder.decodeObjectForKey(PropertyKey.longitude + clientId) as? CLLocationDegrees
        var location:MKPointAnnotation? = nil
        if latitude != nil && longitude != nil {
            location = MKPointAnnotation()
            location!.coordinate.latitude = latitude!
            location!.coordinate.longitude = longitude!
        }
        self.init( firstName: firstName, secondName: secondName, number: number, mail: mail, photo: photo, group: group, location: location)
    }
}
