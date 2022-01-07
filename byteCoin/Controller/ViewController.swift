//
//  ViewController.swift
//  byteCoin
//
//  Created by ShreeThaanu on 25/12/21.
//  Copyright © 2021 sriram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var ETHLabel: UILabel!
    @IBOutlet weak var EthcurrencyLabel: UILabel!
    
    var currencyManager = CurrencyManager()
    

    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyManager.delegate = self
        
        // didUpdatePrice(rate: String, currency: String)
        
    
        
    }

}

//MARK: - UIPicker Data source and picker

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurreny = currencyManager.currencyArray[row]
        //print(selectedCurreny)
        
        DispatchQueue.main.async {
            self.currencyManager.getETHValue(for: selectedCurreny)
            self.currencyManager.getCurrencyValue(for: selectedCurreny)
        }
        

    }
     
 }

//MARK: - CoinManagerDelegate

extension ViewController : CoinManagerDelegate {
    
    func didUpdateETHprice(rate: String, currency: String) {
        ETHLabel.text = rate
        EthcurrencyLabel.text = currency
    }
    
    
    func didUpdatePrice(rate: String, currency: String) {
        currencyLabel.text = rate
        bitcoinLabel.text = currency
    }
    
    func didFailWithError(error: Error) {
        print(error)
        
    }
    
}

