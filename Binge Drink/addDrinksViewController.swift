//
//  addDrinksViewController.swift
//  
//
//  Created by Kendall Lewis on 4/1/18.
//

import UIKit

var drinks =
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
     Drink(drinkName: "bud heavy", drinkClass: "Beer", drinkAmount: Float(2.7)),
     Drink(drinkName: "bud light", drinkClass: "Beer", drinkAmount: Float(9)),
     Drink(drinkName: "blue moon", drinkClass: "Beer", drinkAmount: Float(4.5)),
     Drink(drinkName: "chrona", drinkClass: "Beer", drinkAmount: Float(4.5))]


var searchListIndex = 0;

class searchDrinkCell: UITableViewCell{
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkClass: UILabel!
}

class addDrinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredDrinks = [Drink]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        /****** Search Bar ******/
        filteredDrinks = drinks
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchBar
        tableView.backgroundColor = UIColor.clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDrinks.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{//displays cells
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! searchDrinkCell!
        if cell == nil {
            tableView.register(searchDrinkCell.classForCoder(), forCellReuseIdentifier: "Cell") //Cell name "searchCell"
            cell = searchDrinkCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        if let label = cell?.drinkName{ //populate cell with drink name
            label.text = filteredDrinks[indexPath.row].drinkName
        }
        else{
            cell?.drinkName?.text = filteredDrinks[indexPath.row].drinkName
        }
        if let label = cell?.drinkClass{ //populate cell with drink name
            label.text = filteredDrinks[indexPath.row].drinkClass
        }
        else{
            cell?.drinkClass?.text = filteredDrinks[indexPath.row].drinkClass
        }
        return(cell)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchListIndex = indexPath.row //cell that was selected
        drinkMenuList.append(drinkMenuList[indexPath.row])
        performSegue(withIdentifier: "mainSegue", sender: self)//segues to the next the page
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! != ""  {// Filter the results
            filteredDrinks = drinks.filter { $0.drinkName.lowercased().contains(searchBar.text!.lowercased()) || $0.drinkClass.lowercased().contains(searchBar.text!.lowercased())} //search drink name and drink class
        }else{
            filteredDrinks = drinks
        }
        self.tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchBar.text! != ""  {// Filter the results
            filteredDrinks = drinks.filter { $0.drinkName.lowercased().contains(searchBar.text!.lowercased()) || $0.drinkClass.lowercased().contains(searchBar.text!.lowercased())} //search drink name and drink class
        }else{
            filteredDrinks = drinks
        }
        self.tableView.reloadData()
    }
    
    //Hide keyboard when the users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    //presses the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchController.resignFirstResponder()//hides keyboard
        return(true)
    }
}

