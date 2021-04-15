//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Edison Enerio on 4/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipPercSlider: UISlider!
    
    @IBOutlet weak var tipPercVal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //list the supproted currencies
        listCurrencies.append(Currency(currName: "locale Currency", cSym: "$$", gSize: 3))
        listCurrencies.append(Currency(currName: "US Dollar", cSym: "$", gSize: 3))
        listCurrencies.append(Currency(currName: "Japanese Yen", cSym: "¥", gSize: 4))
        listCurrencies.append(Currency(currName: "English Pound", cSym: "£", gSize: 3))
        listCurrencies.append(Currency(currName: "Philippine Peso", cSym: "₱", gSize: 3))
        
        self.title = "Tip Calculator"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //to check if dark mode is enabled. Needs to be in the viewWillAppear to check when user is loading the main menu
        if dm.isDarkM {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        let percFormat = NumberFormatter()
        percFormat.numberStyle = .percent
        
        let formattedRateL = percFormat.string(from: NSNumber(value: currDefaults[0]))
        let formattedRateM = percFormat.string(from: NSNumber(value: currDefaults[1]))
        let formattedRateR = percFormat.string(from: NSNumber(value: currDefaults[2]))
        
        //updating default rates in case of a change
        tipControl.setTitle(formattedRateL, forSegmentAt: 0)
        tipControl.setTitle(formattedRateM, forSegmentAt: 1)
        tipControl.setTitle(formattedRateR, forSegmentAt: 2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("view did appear")
        
        //Tip control event listener
        tipControl.addTarget(self, action:  #selector(sliderValUpdate(_:)), for: .valueChanged)
        
        //Tip rate slider event listener
        tipPercSlider.addTarget(self, action: #selector(calculateTipWithSliderVal), for: .valueChanged)
        billAmountTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("view will disappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("view did disappear")
    }
    
    let localeCurrency = Locale.current
        
    @IBAction func calculateTip(_ sender: Any){
        let tipPercentages = [currDefaults[0], currDefaults[1], currDefaults[2]]

        //Currency format settings for the results
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSize = currCurrency.gSize
        numberFormatter.groupingSeparator = ","
        if customCurrency{
            numberFormatter.currencySymbol = currCurrency.cSym
        } else {
            numberFormatter.currencySymbol = localeCurrency.currencySymbol
        }
        
        //Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        //Calculate tip by multiplying bill with one the selected default rate
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        
        //Calculate total by adding the calculated tip to the bill
        let total = bill + tip
        
        //Rate output for user's visual info
        tipPercVal.text = String(format: "%.2f", tipPercentages[tipControl.selectedSegmentIndex]*100)

        
        //Update Tip Amount Label
        let formattedTip = numberFormatter.string(from: NSNumber(value: tip))
        tipAmountLabel.text = formattedTip
        
        //Update Total Amount
        let formattedTotal = numberFormatter.string(from: NSNumber(value: total))
        totalLabel.text = formattedTotal
        
        
        
        //Bill amount event listener
        billAmountTextField.addTarget(self, action: #selector(calculateTip), for: .editingChanged)
    }
    
    
    //in case slider is used instead of the default values
    @IBAction func calculateTipWithSliderVal(_ Sender: Any){
        //Currency format settings for the results
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSize = currCurrency.gSize
        numberFormatter.groupingSeparator = ","
        if customCurrency{
            numberFormatter.currencySymbol = currCurrency.cSym
        } else {
            numberFormatter.currencySymbol = localeCurrency.currencySymbol
        }
        
        //Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        //Get tip rate via slider
        let currSliderVal = sliderValGrab(slider: tipPercSlider)
        
        //Calculate tip by multiplying bill with selected rate via slider
        let tip = bill * currSliderVal
        
        //Calculate total by adding the calculated tip to the bill
        let total = bill + tip
        
        //Rate output for user's visual info
        tipPercVal.text = String(format: "%.2f", currSliderVal*100)

        
        //Update Tip Amount Label with the correct currency format
        let formattedTip = numberFormatter.string(from: NSNumber(value: tip))
        tipAmountLabel.text = formattedTip
        
        //Update Total Amount with the correct currency format
        let formattedTotal = numberFormatter.string(from: NSNumber(value: total))
        totalLabel.text = formattedTotal
        
        //Bill amount event listener
        billAmountTextField.addTarget(self, action: #selector(calculateTipWithSliderVal), for: .editingChanged)
        
        //Tip control event listener
        tipControl.addTarget(self, action:  #selector(sliderValUpdate(_:)), for: .valueChanged)
        
    }
    
    //udpate the slider value when default values are selected
    @IBAction func sliderValUpdate(_ sender: Any){
        let tipPercentages = [currDefaults[0], currDefaults[1], currDefaults[2]]

        let sliderInitialVal = tipPercentages[tipControl.selectedSegmentIndex] * 100
        tipPercSlider.setValue(Float(sliderInitialVal), animated: true)
    }
    
    //slider value getter to get the appropriate Rate the user has chosen
    func sliderValGrab(slider: UISlider) -> Double{
        let sliderCurrVal = Double(slider.value)/100
        return sliderCurrVal
    }
    
}

