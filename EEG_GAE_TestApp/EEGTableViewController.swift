//
//  EEGTableViewController.swift
//  EEG_GAE_TestApp
//
//  Created by Graeme Cox on 2017-07-06.
//  Copyright © 2017 Graeme Cox. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase

class EEGTableViewController: UITableViewController {

    //MARK: Properties
    //var ref = Database.database().reference(withPath: "Patient")
    var eegData = [EEG]() //create an array of our EEG objects
    var ref:DatabaseReference?
    //var databaseHandle:DatabaseHandle?
    
    //MARK: Private Methods
    
    private func updateDatabase(){
        /*
 This function will grab Patients from the database, and add them to the listview
 
 */
        ref = Database.database().reference(withPath: "Patient")
        
        ref?.observe(.childAdded, with: { snapshot in
            print(snapshot)
            if let userDict = snapshot.value as? [String:Any] {
                let name = userDict["Name"]
                let date = userDict["Date"]
                let length = userDict["Length"]
                guard let tempEeg = EEG(name: name as! String, setLength: length as! Int , timestamp: date as! String)
                    else {
                        fatalError("Unable to instantiate tempEeg")
                }
                
               // self.eegData += [tempEeg]
                
              //  let newIndexPath = IndexPath(row: self.eegData.count, section: 0)
                
                self.eegData.append(tempEeg) // adds new row at end
                
                self.tableView.reloadData()
                
                
                
            }
        })
    }
    
    
    func loadSampleDataSets(){ //Load inital data sets
        //let photo1 = UIImage(named: "meal1")
 
        // if we want to load images of the graphs, do that here too. See above comment
        
        
        guard let eeg1 = EEG(name: "A while ago", setLength: 100, timestamp:"04072017_1123")
        else {
            fatalError("Unable to instantiate eeg1")
        }
        guard let eeg2 = EEG(name: "Yesterday", setLength: 50, timestamp:"07062017_2210")
        else {
            fatalError("Unable to instantiate eeg2")
        }
        guard let eeg3 = EEG(name: "This morning", setLength: 20, timestamp:"07062017_1123")
        else {
            fatalError("Unable to instantiate eeg3")
        }
        
        eegData += [eeg1,eeg2,eeg3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // loadSampleDataSets()// load initial sample sets
        updateDatabase()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eegData.count //return number of table rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EEGTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EEGTableViewCell else{
            fatalError("The dequeued cell is not an instance of EEGTableViewCell.:")
        }
        
        let eeg = eegData[indexPath.row]
        //update cell properties to current EEG class
        cell.nameLabel.text = eeg.name
        cell.dataLengthLabel.text = String(eeg.setLength)
        cell.additionalNotes.text = eeg.timestamp

        // Configure the cell...

        return cell
    }
    
    
    //MARK: Actions
    @IBAction func unwindToEEGList(sender: UIStoryboardSegue){
        if let sourceViewController =  sender.source as?
            EEGViewController, let eeg = sourceViewController.eeg{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing meal
                eegData[selectedIndexPath.row] = eeg
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }
            else{
                //Add a new eeg set
                let newIndexPath = IndexPath(row: eegData.count, section: 0)
                
                eegData.append(eeg) // adds new row at end
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
            case "AddItem":
                os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            case "ShowDetail":
                guard let EEGDetailViewController = segue.destination as? EEGViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedEEGCell = sender as? EEGTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedEEGCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedEEG = eegData[indexPath.row]
                EEGDetailViewController.eeg = selectedEEG
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
            
        }
    }
    

}
