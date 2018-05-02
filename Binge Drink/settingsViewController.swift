//
//  settingsViewController.swift
//  
//
//  Created by Kendall Lewis on 4/2/18.
//

import UIKit

var age :Float = 0
var weight :Float = 0
var genderIndex :Int = 0 //gender Index number
var gender :Float = 0 //gender constant

class settingsViewController: UIViewController {

    @IBOutlet weak var enterAge: UITextField!
    @IBOutlet weak var enterWeight: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl! //gender switch controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //enter the user saved data
        if let savedAge = UserDefaults.standard.object(forKey: "enteredAge") as? String{
            enterAge.text = "\(savedAge)" //display the users saved age in the enterAge field
            //print(savedAge)
        }
        if let savedWeight = UserDefaults.standard.object(forKey: "enteredWeight") as? String{
            enterWeight.text = "\(savedWeight)" //display the users saved weight in the enterWeight field
            //print(savedWeight)
        }
    }
    
    @IBAction func submitUserSettings(_ sender: Any) {
        getVars()
        UserDefaults.standard.set(enterAge.text, forKey: "enteredAge") //save the users entered age
        UserDefaults.standard.set(enterWeight.text, forKey: "enteredWeight")//save the users entered weight
    }
    
    func getVars(){
        let enteredWeight = Float(enterWeight.text!) //weight equals the weight entered value
        let enteredAge = Float(enterAge.text!)    //age equals the weight entered value
        age = Float(enteredAge!) //store in the age variable
        weight = Float(enteredWeight!) //store in the weight variable
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) { //gender switch control
        if genderSegmentedControl.selectedSegmentIndex == 0{ //first switch male
            
            gender = 0.68 //save male gender constant
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "enteredGender") //save the users gender selection
            //UserDefaults.standard.set(gender, forKey: "enteredGender") //save the users gender constant
            genderIndex = 1
            //print("first one")
        }else if genderSegmentedControl.selectedSegmentIndex == 1{ //second switch for female
            gender = 0.55 //save male gender constant
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "enteredGender") //save the users gender selection
            //UserDefaults.standard.set(gender, forKey: "enteredGender") //save the users gender constant
            genderIndex = 1
            //print("second one")
        }
    }
}
