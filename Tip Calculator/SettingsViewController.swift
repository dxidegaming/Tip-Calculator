//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by Edison Enerio on 4/11/21.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "supportedCurrencies", for: indexPath)
               
               listCell.textLabel!.text = String( listCurrencies[indexPath.row].currName)
               
               return listCell
    }
    
    
    
    @IBOutlet weak var darkMode: UISwitch!
    
    @IBOutlet weak var defRateLeft: UILabel!
    
    @IBOutlet weak var defRateMid: UILabel!
    
    @IBOutlet weak var defRateRight: UILabel!
    
    @IBOutlet weak var newRateLeft: UITextField!
    
    @IBOutlet weak var newRateMid: UITextField!
    
    @IBOutlet weak var newRateRight: UITextField!
    
    
    @IBOutlet var dropDownCurr: UITableView!{
        didSet {
            dropDownCurr.dataSource = self
            dropDownCurr.delegate = self
            dropDownCurr.remembersLastFocusedIndexPath = true
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRateLeft.becomeFirstResponder()
        //to check if dark mode is enabled
        if dm.isDarkM {
            overrideUserInterfaceStyle = .dark
            darkMode.setOn(true, animated: true)
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        //to show default rates
        defRateLeft.text = String(currDefaults[0] * 100)
        defRateMid.text = String(currDefaults[1] * 100)
        defRateRight.text = String(currDefaults[2] * 100)
        
        darkMode.addTarget(self, action: #selector(isDarkMode), for: .valueChanged)
        
        self.title = "Settings"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        //to check if user has input on new default rates
        let tempLeft = Double(newRateLeft.text!) ?? 0
        let newLeft = tempLeft / 100
        let tempMid = Double(newRateMid.text!) ?? 0
        let newMid = tempMid / 100
        let tempRight = Double(newRateRight.text!) ?? 0
        let newRight = tempRight / 100
        if isEmpty(newRateLeft){
            currDefaults[0] = newLeft
        
        }; if isEmpty(newRateMid) {
            currDefaults[1] = newMid
        }; if isEmpty(newRateRight) {
            currDefaults[2] = newRight
        }
        
        //to check if user changed the currency
        
        let currentIndex = dropDownCurr.indexPathForSelectedRow?.row
        
        currCurrency = listCurrencies[currentIndex ?? defaultIndex]
        if currentIndex != nil && currentIndex != 0{
            defaultIndex = currentIndex ?? 0
            customCurrency = true
        } else {
            customCurrency = false
        }
        viewDidLoad()
    }

    //to keep track of total currencies supported
    func numberOfCurrencySupported(tableView: UITableView) -> Int {
        return Currency.numOfSupportedCurrencies
    }
    
    //to keep the dark mode switch updated
    @IBAction func isDarkMode(_ sender: Any){
        if darkMode.isOn {
            dm.isDarkM = true
            viewDidLoad()
        } else {
            dm.isDarkM = false
            viewDidLoad()
        }
    }
    
    //to check if the user did not provide any input on the new default rate text fields
    func isEmpty (_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty{
            return true
        } else {
            return false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
