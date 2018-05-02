//
//  ViewController.swift
//  Binge Drink
//
//  Created by Kendall Lewis on 3/22/18.
//  Copyright © 2018 Kendall Lewis. All rights reserved.
//

import UIKit

/*****Arrays*****/
var drinkMenuList =
    [Drink(drinkName: "Vodka", drinkClass: "liqour",drinkAmount: Float(6.5)),
     Drink(drinkName: "rum", drinkClass: "liqour", drinkAmount: Float(3.5)),
     Drink(drinkName: "jin", drinkClass: "liqour", drinkAmount: Float(4.5)),
     Drink(drinkName: "ciroc", drinkClass: "liqour", drinkAmount: Float(2.5)),
     Drink(drinkName: "Captain Morgan", drinkClass: "liqour", drinkAmount: Float(7)),
     Drink(drinkName: "rumple", drinkClass: "liqour", drinkAmount: Float(4.5)),
     Drink(drinkName: "premium", drinkClass: "liqour", drinkAmount: Float(7.5)),
     Drink(drinkName: "pucker", drinkClass: "liqour", drinkAmount: Float(4.5)),
     Drink(drinkName: "absolute", drinkClass: "liqour", drinkAmount: Float(4)),
     Drink(drinkName: "everclear", drinkClass: "liqour", drinkAmount: Float(3.8)),
     Drink(drinkName: "onyx", drinkClass: "Beer", drinkAmount: Float(2.7)),
     Drink(drinkName: "bud light", drinkClass: "Beer", drinkAmount: Float(9)),
     Drink(drinkName: "blue moon", drinkClass: "Beer", drinkAmount: Float(4.5)),
     Drink(drinkName: "chrona", drinkClass: "Beer", drinkAmount: Float(4.5))]
var menuList = [menuDisplay(menuItem: "MyAccount", menuDetails: Int(1)),
                menuDisplay(menuItem: "Feed", menuDetails: Int(0)),
                menuDisplay(menuItem: "History", menuDetails: Int(3)),
                menuDisplay(menuItem: "Options", menuDetails: Int(0)),
                menuDisplay(menuItem: "Logout", menuDetails: Int(9))]
/*****variables********/
var drinkListIndex = 0;
var menuListIndex = 0;
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
var getDrinkMenu = true
/******Classes*******/
class drinkCell: UITableViewCell{ //Edit the drink cells
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkType: UILabel!
    @IBOutlet weak var drinkAmount: UILabel!
    @IBInspectable var selectionColor: UIColor = .white {//adds selection color feature
        didSet {
            configureSelectedBackgroundView()
        }
    }
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
        view.layer.masksToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 4
    }
}
class menuCell: UITableViewCell{ //Edit the menu cells
    @IBOutlet weak var menuItem: UILabel!
    @IBOutlet weak var menuDetails: UILabel!
    @IBInspectable var selectionColor: UIColor = .black {//adds selection color feature
        didSet {
            configureSelectedBackgroundView()
        }
    }
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
        view.layer.masksToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 4
    }
}
class Drink {
    var drinkName = ""
    var drinkClass = ""
    var drinkAmount = 0.00
    init(drinkName: String, drinkClass:String, drinkAmount:Float) {
        self.drinkName = drinkName
        self.drinkClass = drinkClass
        self.drinkAmount = Double(drinkAmount)
    }
}
class menuDisplay {
    var menuItem = ""
    var menuDetails = 0
    init(menuItem: String, menuDetails:Int) {
        self.menuItem = menuItem
        self.menuDetails = menuDetails
    }
}

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var ubeView: UIView!//holds main view for user
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!//constraint for left side of view
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!//constraint for right side of view
    @IBOutlet weak var mainBACDisplay: UILabel! //Main label View
    @IBOutlet weak var drinksTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainMenuView: UIView! //menu view on the left
    @IBOutlet weak var mainDrinksMenuView: UIView! //drinks menu view on the right
    @IBOutlet weak var submitDrinkButton: UIButton!
    @IBOutlet weak var mainDisplay: UIView! //Displays the bac etc
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userImage: UIView!
    @IBOutlet weak var drinksLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bacIndicator: UIProgressView!

    /******** variables ***********/
    var myString = String()
    var name = String() //gather string name from settingsViewController
    var userWeight = Float() //might be able to delete
    var userAge = Float() //might be able to delete
    var userGender = Float() //might be able to delete
    var cell : UITableViewCell!
    var hamburgerMenusIsVisible = false//sets menu to close
    var mainDrinksMenuIsVisible = false // sets menu to false
    var resetCalcActive = false
    let shapeLayer = CAShapeLayer()
    
    
    var progressValue = 0.0
    let progressShape = CAShapeLayer()
    let backgroundShape = CAShapeLayer()
    let percent = 50.0
    @IBInspectable open var value: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Populate drink menu */
        let menuIndexPath = IndexPath(row: menuList.count - 1, section: 0)
        let indexPath = IndexPath(row: drinkMenuList.count - 1, section: 0)
        /*********menu table view*********/
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        menuTableView.beginUpdates()
        menuTableView.insertRows(at: [menuIndexPath], with: .automatic) //insert rows at tableview
        menuTableView.endUpdates()
        menuTableView.tableFooterView = UIView(frame: .zero) //remove empty rows in tableView
        /**********Table view*************/
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        /*Submit button attributes*/
        submitDrinkButton.layer.shadowColor = UIColor.black.cgColor //submit button shadow color
        submitDrinkButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0) //submit button offset shadow
        submitDrinkButton.layer.masksToBounds = false
        submitDrinkButton.layer.shadowRadius = 3.0 //submit button shadow radius
        submitDrinkButton.layer.shadowOpacity = 0.5 //submit button opacity
        //submitDrinkButton.layer.cornerRadius = 25.0 //submit button radius
       /*navigation attribute*/    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default) //hide nav bar border
        self.navigationController?.navigationBar.shadowImage = UIImage() //hide nav bar border
        navigationController?.navigationBar.barTintColor = UIColor.darkGray // navbar color
        /* main menu display attributes*/
        backgroundImage.layer.shadowColor = UIColor.black.cgColor //main display shadow color
        backgroundImage.layer.shadowOffset = CGSize.zero //main display shadow offset
        backgroundImage.layer.masksToBounds = false
        backgroundImage.layer.shadowRadius = 5.0 //main display shadow radius
        backgroundImage.layer.shadowOpacity = 1 //main display shadow opacity
        backgroundImage.layer.shouldRasterize = true //cache rendering to save time
        //mainDisplay.layer.cornerRadius = 10.0 //main display corner radius
        /**** Hide all menus ***/
        self.mainMenuView.isHidden = true //hide main menu at start
        self.mainDrinksMenuView.isHidden = true // hide drinks menu at start
        
        
        /******UserImage circle********/
        userImage.layer.cornerRadius = 60.0
        
        bacIndicator.transform = bacIndicator.transform.scaledBy(x: 1, y: 20)
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        
        let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        //progressRing.setProgress(value:30, animationDuration: 0.5)
        progressRing.maxValue = 100
        // Assign the delegate
        progressRing.delegate = self as? UICircularProgressRingDelegate
        progressRing.layer.shadowColor = UIColor.clear.cgColor
        // Add the view as a subview or whatever else you would like to do
        
    
    }
    @objc func updateProgress() {
        progressValue = Double(calculatedBAC)
        self.bacIndicator.progress = Float(calculatedBAC)
        if progressValue != 0.8 { //Change to 0.08
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        }
    }

    
    func updateIndicator(with percent: Double, isAnimated: Bool = false) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressShape.strokeEnd
        animation.toValue = percent / 100.0
        animation.duration = 2.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        
        
        let shortestSide = min(view.frame.size.width, view.frame.size.height) - 30
        let strokeWidth: CGFloat = 40.0
        let frame = CGRect(x: 0, y: 0, width: shortestSide - strokeWidth, height: shortestSide - strokeWidth)
        
        
        backgroundShape.frame = frame
        backgroundShape.position = view.center
        backgroundShape.path = UIBezierPath(ovalIn: frame).cgPath
        backgroundShape.strokeColor = UIColor.black.cgColor
        backgroundShape.lineWidth = strokeWidth
        backgroundShape.fillColor = UIColor.clear.cgColor
        
        progressShape.frame = frame
        progressShape.path = backgroundShape.path
        progressShape.position = backgroundShape.position
        progressShape.strokeColor = UIColor.red.cgColor
        progressShape.lineWidth = backgroundShape.lineWidth
        progressShape.fillColor = UIColor.clear.cgColor
        progressShape.strokeEnd = CGFloat(percent/100.0)
        
        if isAnimated {
            progressShape.add(animation, forKey: nil)
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateIndicator(with: percent, isAnimated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        // code to check for a particular tableView.
        if tableView == self.menuTableView //access the menu table view
        {
            count = menuList.count
        }
        if tableView == self.tableView{ //access the drinks table view
            count = drinkMenuList.count
        }
        return count!
    }
    /******* Table View ********/
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {// code to check for a particular tableView to display the data .
        if tableView == self.menuTableView{ //access the menu table view
            var cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! menuCell!
            if cell == nil {
                tableView.register(menuCell.classForCoder(), forCellReuseIdentifier: "menuCell") //Cell name "searchCell"
                cell = menuCell(style: UITableViewCellStyle.default, reuseIdentifier: "menuCell")
            }
            if let label = cell?.menuItem{ //populate cell with menu item name
                label.text = menuList[indexPath.row].menuItem
            }
            else{
                cell?.textLabel?.text = menuList[indexPath.row].menuItem
            }
            if let label = cell?.menuDetails{ //populate cell with menu details
                if menuList[indexPath.row].menuDetails == 0{ //if menu detail is 0 do not display
                    label.text = ""
                }else{
                    label.text = String(menuList[indexPath.row].menuDetails)
                }
            }
            else{
                if menuList[indexPath.row].menuDetails == 0{ ////if menu detail is 0 do not display
                    cell?.textLabel?.text = ""
                }else{
                    cell?.textLabel?.text = String(menuList[indexPath.row].menuDetails)
                }
            }
            return cell!
        }
        if tableView == self.tableView{ //access the drinks table view
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! drinkCell!
            if cell == nil {
                tableView.register(drinkCell.classForCoder(), forCellReuseIdentifier: "cell")
                cell = drinkCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            }
            if let label = cell?.drinkName{ //populate cell with drink name
                label.text = drinkMenuList[indexPath.row].drinkName
            }
            else{
                cell?.textLabel?.text = drinkMenuList[indexPath.row].drinkName
            }
            
            if let label = cell?.drinkType{//populate cell with drink class/type
                label.text = drinkMenuList[indexPath.row].drinkClass
            }
            else{
                cell?.textLabel?.text = drinkMenuList[indexPath.row].drinkClass
            }
            
            if let label = cell?.drinkAmount{ //populate cell with alcohol in drink
                label.text = String(drinkMenuList[indexPath.row].drinkAmount)
            }
            else{
                cell?.textLabel?.text = String(drinkMenuList[indexPath.row].drinkAmount)
            }
            return cell!
        }
        return cell
    }
    /******** Delete table rows ********/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {//deletes rows
        if tableView == tableView{
            if (editingStyle == .delete){
                drinkMenuList.remove(at: indexPath.item) //removes drink
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {//disables swipe to delete function for specific cells
        if tableView == menuTableView { //access the menu table view
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView{
            drinkListIndex = indexPath.row //cell that was selected
        }
        if tableView == menuTableView{
            if menuList[indexPath.row].menuItem == "MyAccount"{
               print("My Account")
                //performSegue(withIdentifier: "settings", sender: self)//segues to the settings page
            } else if menuList[indexPath.row].menuItem == "Feed"{
                print("Feed")
                //performSegue(withIdentifier: "settings", sender: self)//segues to the feed page
            }else if menuList[indexPath.row].menuItem == "History"{
                print("History")
                //performSegue(withIdentifier: "History", sender: self)//segues to the history page
            }else if menuList[indexPath.row].menuItem == "Options"{
                print("Settings")
                performSegue(withIdentifier: "settings", sender: self)//segues to the settings page
            }else if menuList[indexPath.row].menuItem == "Logout"{
                print("Logout")
                /*********************************/
                /*******Add logout feature********/
                /*********************************/
            }
        }
    }
    var activeCheck = true
    @IBAction func hamburgerBtnTapped(_ sender: Any) {//hamburger menu button located on the left
        self.mainMenuView.isHidden = false
        self.mainDrinksMenuView.isHidden = true//hide drinks menu
        if !hamburgerMenusIsVisible{ //If menu is not visible, display menu
            if drinksLeadingConstraint.constant != -250 && drinksTrailingConstraint.constant != 250{
                drinksTrailingConstraint.constant = 0
                drinksLeadingConstraint.constant = 0
                leadingConstraint.constant = 325 //shift to 325
                trailingConstraint.constant = -325 //sift to  -32
                self.mainDrinksMenuView.isHidden = true//hide drinks menu
                print("menu Active")
            }else{
                drinksTrailingConstraint.constant = 0
                drinksLeadingConstraint.constant = 0
                leadingConstraint.constant = 325 //shift to 325
                trailingConstraint.constant = -325//sift to  -32
                self.mainDrinksMenuView.isHidden = true//hide drinks menu
                print("return to menu Active")
            }
            hamburgerMenusIsVisible = true //set main menu to true
        }else{//if menu is visible move the menu back
            leadingConstraint.constant = 10 //reset main menu back to zero
            trailingConstraint.constant = 0 // reset main menu back to zero
            drinksLeadingConstraint.constant = 0
            drinksTrailingConstraint.constant = 10
            hamburgerMenusIsVisible = false //set main menu to false
            mainDrinksMenuIsVisible = false
            self.mainDrinksMenuView.isHidden = true//hide drinks menu
            self.mainMenuView.isHidden = true//hide drinks menu
            print("close menu Active")
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {//animation for menu
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func drinksHamburgerBtnTapped(_ sender: Any) {//hamburger drink menu button located on the right
        if !mainDrinksMenuIsVisible{ //If menu is not visible, display menu
            self.mainDrinksMenuView.isHidden = false // show drinks menu
            if leadingConstraint.constant != 325 && trailingConstraint.constant != -325{
                leadingConstraint.constant = 0 //shift to 325
                trailingConstraint.constant = 0
                drinksLeadingConstraint.constant = -250
                drinksTrailingConstraint.constant = 250
                print("drinks Active")
            }else{
                leadingConstraint.constant = 0 //shift to 325
                trailingConstraint.constant = 0
                drinksLeadingConstraint.constant = -250
                drinksTrailingConstraint.constant = 250
                print("return to drinks Active")
            }
            self.mainMenuView.isHidden = true
            mainDrinksMenuIsVisible = true
            //mainDrinksMenu = true
        }else{//if menu is visible move the menu back
            drinksLeadingConstraint.constant = 10
            drinksTrailingConstraint.constant = 10
            mainDrinksMenuIsVisible = false
            hamburgerMenusIsVisible = false //set main menu to false
            self.mainMenuView.isHidden = true
            self.mainDrinksMenuView.isHidden = true // hide drinks menu
            print("close drinks Active")
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {//animation for menu
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func addDrinkButton(_ sender: Any) { //Add more drinks to BAC
        numberOfDrinks += 1 //adds 1 to the amount consumed
        weightGrams = weight * 453.592 //68,038.8
        alcoholConsumedGrams = ((alcoholOunces * numberOfDrinks) * alcoholPercentage) * 28.3495 //17.0097
        
        totalAlcoholGrams = (weightGrams * gender) //37,421.34
        rawBAC = (alcoholConsumedGrams / totalAlcoholGrams)//0.0004545454545
        metabolism =  (hoursConstant * hoursDrinking) //0.015
        calculatedBAC = (rawBAC * 100) - metabolism
        print(rawBAC)
        print(alcoholConsumedGrams)
        print(totalAlcoholGrams)
        //let BAC = round(100.0 * calculatedBAC) / 100.0 //convert to tenths
        mainBACDisplay.text = "\(calculatedBAC)" //Displays final BAC
    }
    @IBAction func resetCalc(_ sender: Any) {
        numberOfDrinks = 0 //adds 1 to the amount consumed
        rawBAC = (alcoholConsumedGrams / totalAlcoholGrams)//0.0004545454545
        hoursDrinking = 0
        calculatedBAC = 0.0
        mainBACDisplay.text = "\(calculatedBAC)" //Displays final BAC
        progressValue = 0.0
    }


}
