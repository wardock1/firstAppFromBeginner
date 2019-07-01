//
//  CurrencyService.swift
//  NewCurrencyProject
//

import Foundation


struct CurrencyService: Decodable {
	
	var key: String
	var value: Double
	
	init(key: String, value: Double) {
		self.key = key
		self.value = value
	}
	
	static func fetchData (completion: @escaping ([CurrencyService]) -> ()) {
		
		let url = "MAKR,below"
		guard let urlString = URL(string: url) else { return }
		
		URLSession.shared.dataTask(with: urlString) { (data, _, _) in
			guard let data = data else { return }

			do {
				let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
				guard let getData = jsonResponse as? [String: Any] else { return }
				var newDictionary = [CurrencyService]()
				
				let rates = getData["rates"] as? [String: Double]
				
				_ = rates?.map {(key: String, value: Any) in
					if key == "USD" || key == "GBP" {
						let v = value as? Double
						let data = CurrencyService.init(key: key, value: v ?? 0)
						newDictionary.append(data)
					}
				}
				
				let baseCurrency = getData["base"]
				let bC = CurrencyService(key: baseCurrency as! String, value: 1)
				newDictionary.append(bC)
				
				completion(newDictionary)
				
			} catch {
				print("Got error when parsing")
			}
			}.resume()
	}
	
}


// MARK: API: 	{"base":"EUR","rates":{"GBP":0.89655,"HKD":8.8866,"IDR":16083.35,"ILS":4.0607,"DKK":7.4636,"INR":78.524,"CHF":1.1105,"MXN":21.8201,"CZK":25.447,"SGD":1.5395,"THB":34.897,"HRK":7.3973,"MYR":4.7082,"NOK":9.6938,"CNY":7.8185,"BGN":1.9558,"PHP":58.335,"SEK":10.5633,"PLN":4.2496,"ZAR":16.1218,"CAD":1.4893,"ISK":141.7,"BRL":4.3511,"RON":4.7343,"NZD":1.696,"TRY":6.5655,"JPY":122.6,"RUB":71.5975,"KRW":1315.35,"USD":1.138,"HUF":323.39,"AUD":1.6244},"date":"2019-06-28"}
