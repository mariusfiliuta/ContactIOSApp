//
//  ViewController.swift
//  Contact
//
//  Created by intern on 13/07/16.
//  Copyright © 2016 intern. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up Delegates
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        numberTextField.delegate = self
        mailTextField.delegate = self
        
        //
        
        
        if let contact = contact {
            photoImageView.image = contact.photo
            firstNameTextField.text = contact.firstName
            secondNameTextField.text = contact.secondName
            numberTextField.text = contact.number
            mailTextField.text = contact.mail
            
        }
        else{
            saveButton.enabled = false
        }
        // checkValidContact()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var contact: Contact?
    
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode{
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController!.popViewControllerAnimated(true)
        }
    }
    @IBAction func selectImageFromLibary(sender: UITapGestureRecognizer) {
        // Hide keyboard
        hideKeyboard()
        // Instatiate ImagePickerController
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        hideKeyboard()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidContact()
        
    }
    func checkValidContact(){
        // Disable the Save button if the text field is empty
        let checker = Contact.checkValidContact(firstNameTextField.text, secondName: secondNameTextField.text, number: numberTextField.text, mail: mailTextField.text)
        
        firstNameTextField.backgroundColor = UIColor.clearColor()
        secondNameTextField.backgroundColor = UIColor.clearColor()
        numberTextField.backgroundColor = UIColor.clearColor()
        mailTextField.backgroundColor = UIColor.clearColor()
        
        saveButton.enabled = false
        if checker.contains(.emptyString) {
            if firstNameTextField.text?.isEmpty == true {
                firstNameTextField.backgroundColor = UIColor.redColor()
            }
            if secondNameTextField.text?.isEmpty == true {
                secondNameTextField.backgroundColor = UIColor.redColor()
            }
            if numberTextField.text?.isEmpty == true {
                numberTextField.backgroundColor = UIColor.redColor()
            }
            if mailTextField.text?.isEmpty == true{
                mailTextField.backgroundColor = UIColor.redColor()
            }
        }
        if checker.contains(.wrongEmailFormat) {
            mailTextField.backgroundColor = UIColor.redColor()
        }
        if checker.contains(.wrongNumberFormat) {
            numberTextField.backgroundColor = UIColor.redColor()
        }
        if checker.isEmpty == true{
            saveButton.enabled = true
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        photoImageView.image = selectedImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func hideKeyboard(){
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
    }
    
    // Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let firstName = firstNameTextField.text ?? ""
            let secondName = secondNameTextField.text ?? ""
            let number = numberTextField.text ?? ""
            let mail = mailTextField.text ?? ""
            let photo = photoImageView.image
            
            contact = Contact(firstName: firstName, secondName: secondName, number: number, mail: mail, photo: photo)
        }
    }
}

