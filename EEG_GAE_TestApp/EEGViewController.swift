 //
//  ViewController.swift
//  EEG_GAE_TestApp
//
//  Created by Graeme Cox on 2017-07-05.
//  Copyright © 2017 Graeme Cox. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase

class EEGViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    var eeg: EEG?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var timeStampField: UITextField!
    @IBOutlet weak var setLengthField: UITextField!
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var timeStampLabel: UITextField!
    
    let ref = Database.database().reference(withPath: "Patient")
  //  let ref = Database.database().reference(withPath: "patient-data")
    
    //MARK: Naviagtion
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let timeStamp = timeStampField.text ?? ""
        var setLength = Int(setLengthField.text ?? "")
        
        
        if (setLength == nil)
        {
            setLengthField.text = "100"
            setLength = 100
        }
        
        eeg = EEG(name: name, setLength: setLength!, timestamp:
            timeStamp)
        
        
        //update Firebase
        let name_fb = self.ref.child(name.lowercased())
        name_fb.setValue(eeg?.toAnyObject())
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        if let eeg = eeg{
            navigationItem.title = eeg.name
            nameTextField.text = eeg.name
            setLengthField.text = String(eeg.setLength)
            timeStampField.text = eeg.timestamp
        }
        
        updateSaveButtonState() // allow save button if field has a valid meal name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    //MARK: UITextFieldDelegate
    
    func textFieldShoudReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder() // hide keyboard
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        saveButton.isEnabled = false //disable save button while editing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
        //disable different ways deoending on modal or push presentation
        let isPresentingInAddEEGMode = presentingViewController is UINavigationController
        
        if isPresentingInAddEEGMode{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The EEGViewController is not inside a navigation controller")
        }
    
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty// disable save button if text field is empty
    }
    
    

}

