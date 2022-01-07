//
//  CurrencyManager.swift
//  byteCoin
//
//  Created by ShreeThaanu on 27/12/21.
//  Copyright © 2021 sriram. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(rate : String, currency : String)
    func didUpdateETHprice(rate : String, currency : String)
    //func updateViewDidLoad (rate: String, currency : String)
    func didFailWithError(error : Error)
}

struct CurrencyManager {
    
    var delegate : CoinManagerDelegate?

    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "8861B93D-762F-4263-ACD5-82E53EDF02FE"
    
    
    var currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCurrencyValue(for currency: String){

        //Step 1 : Create a URL
        let urlString = "\(baseURL)BTC/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {

            //Step 2 : Create a URLSession
            let session = URLSession.shared

            //Step 3 : Create a Task
            let task = session.dataTask(with: url) { (data, response, error) in

                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data{
                    if let bitcoinPrice = self.parseJson(safeData){

                        let priceString = String(format: "%2.f", bitcoinPrice)

                        DispatchQueue.main.async {
                            self.delegate?.didUpdatePrice(rate: priceString, currency: currency)


                        }

                }

            }


            }
            //Step 4 : Start the task
            task.resume()


        }


    }
    
    func getETHValue(for currency: String){
        
        //Step 1 : Create a URL
        let urlString = "\(baseURL)ETH/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            //Step 2 : Create a URLSession
            let session = URLSession.shared
            
            //Step 3 : Create a Task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let ETHPrice = self.parseETHJson(safeData){
                        
                        let priceString = String(format: "%2.f", ETHPrice)
                        
                        
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateETHprice(rate: priceString, currency: currency)
                                

                        }

                }
                
            }
                
                
            }
            //Step 4 : Start the task
            task.resume()

            
        }
        
                
    }


func parseJson(_ coindata: Data) -> Double? {
    let decoder = JSONDecoder()
    
    do {
        let decodeData = try decoder.decode(CoinData.self, from: coindata)
        
        let rate = decodeData.rate
        print(rate)
        return rate
    } catch {
        
        print(error)
        return nil
        
    }
}
    
    func parseETHJson(_ coindata: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(Response.self, from: coindata)
            
            let ETHrate = decodeData.rate
            print("1.\(ETHrate)")
            return ETHrate
        } catch {
            
            print(error)
            return nil
            
        }
    }
    
}
