//
//  SettingsModel.swift
//  Tip Calculator
//
//  Created by Edison Enerio on 4/12/21.
//

import Foundation
var listCurrencies = [Currency]()

class Currency {
    var currName: String
    var cSym: String
    var gSize: Int
    static var numOfSupportedCurrencies = 0
    
    init(currName: String, cSym: String, gSize: Int){
        self.currName = currName
        self.cSym = cSym
        self.gSize = gSize
        
    Currency.numOfSupportedCurrencies += 1
        }
    deinit {
        Currency.numOfSupportedCurrencies -= 1
    }
}

class DarkMode {
    var isDarkM: Bool
    
    init(isDarkM: Bool){
        self.isDarkM = isDarkM
    }
}
var customCurrency = false
//for the dark mode boolean
var dm = DarkMode(isDarkM: false)

//default rate values
var currDefaults = [0.15,0.18,0.2]

//to keep track of the current currency used
var defaultIndex = 0
var currCurrency = listCurrencies[defaultIndex]

