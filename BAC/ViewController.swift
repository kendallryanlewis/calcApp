//
//  ViewController.swift
//  Wingman
//
//  Created by Kendall Lewis on 2/27/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

var alcoholConsumedGrams :Float = 0
var totalAlcoholGrams :Float = 0
var numberOfDrinks :Float = 0
var alcoholPercentage :Float = 0.05//percentag of alcohol
var alcoholOunces :Float = 12 //12 ounces of beer (change this when the drink changes to bigger/small beer, alcohol or wine)
var hoursConstant :Float = 0.015 //motablism constant for male/female (this will be a variable that changes for the male/female)
var hoursDrinking :Float = 1 // (3 hours of drinking)change to make it a variable recorded by time
var metabolism :Float = 0
var weightGrams :Float = 0
var rawBAC :Float = 0
var calculatedBAC :Float = 0

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mainBACDisplay: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var DrinkType: UIButton!
    @IBOutlet weak var DrinkSelector: UIButton!
    
    var name = String() //gather string name from settingsViewController
    var userWeight = Float()
    var userAge = Float()
    var userGender = Float()
    
    override func viewDidLoad() { //first thing loaded
        super.viewDidLoad()

        mainBACDisplay.text = "\(calculatedBAC)" //displays the  calulated BAC and displays within the man BAC display
        //print(calculatedBAC)
        userName.text = name //Displays the users name
        
        self.DrinkSelector.layer.borderWidth = 1
        self.DrinkSelector.layer.borderColor = UIColor (red:222/255, green: 225/255, blue: 227/255, alpha: 1).cgColor
        self.DrinkType.layer.borderWidth = 1
        self.DrinkType.layer.borderColor = UIColor (red:222/255, green: 225/255, blue: 227/255, alpha: 1).cgColor
    }
    
    @IBAction func drinkSelectorButton(_ sender: Any) {
        
    }
    
    @IBAction func drinkTypeButton(_ sender: Any) {
        
    }
    
    
    @IBAction func addDrinkButton(_ sender: Any) { //Add more drinks to BAC
        numberOfDrinks += 1 //adds 1 to the amount consumed
        weightGrams = weight * 453.592 //68,038.8
        alcoholConsumedGrams = ((alcoholOunces * numberOfDrinks) * alcoholPercentage) * 28.3495 //17.0097

        totalAlcoholGrams = (weightGrams * gender) //37,421.34
        rawBAC = (alcoholConsumedGrams / totalAlcoholGrams)//0.0004545454545
        metabolism =  (hoursConstant * hoursDrinking) //0.015
        calculatedBAC = Float((rawBAC * 100) - (metabolism))
        print(rawBAC)
        print(alcoholConsumedGrams)
        print(totalAlcoholGrams)
        let BAC = round(100.0 * calculatedBAC) / 100.0 //convert to tenths
        mainBACDisplay.text = "\(BAC)" //Displays final BAC
    }
}

