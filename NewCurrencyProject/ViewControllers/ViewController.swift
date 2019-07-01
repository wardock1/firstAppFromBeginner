//
//  ViewController.swift
//  NewCurrencyProject
//
//  Created by Dmitry Kutlyev on 17/06/2019.
//  Copyright © 2019 Dmitry Kutlyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var bottomCollectionView: UICollectionView!
	let dataCondition = DataCondition()
	
	var dataOfCurrency = [CurrencyService]()
	
	var listOfTopBalance = ["EUR": 100.00, "USD": 80.00, "GBP": 50.00]
	var listOfBottomBalance = ["EUR": 90.00, "USD": 70.00, "GBP": 40.00]
	
	@IBAction func exhaustButtonTap(_ sender: UIBarButtonItem) {
		
		if dataCondition.bottomTextField == nil {
			let calculatedCurrency = dataCondition.calculateFromTopText(topTextField: dataCondition.topTextField ?? 0, topCurrency: dataCondition.topCurrency ?? 0, bottomCurrency: dataCondition.bottomCurrency ?? 0)
			
			let valueOfListTopBalance = searchValueInListOfTopBalance()
			let valueOfListBottomBalance = searchValueOfListBottomBalance()
			
			let calculatedBalanceForTop = dataCondition.calculateTopBalance(currentTopBalance: valueOfListTopBalance, currentTextField: dataCondition.topTextField ?? 0)
			let calculatedBalanceForBottom = dataCondition.calculateBottomBalance(dataAfterCalculated: Double(calculatedCurrency) ?? 0, currentBottomBalance: valueOfListBottomBalance)
			
			listOfTopBalance.updateValue(calculatedBalanceForTop, forKey: dataCondition.nameCurrencyForTop!)
			listOfBottomBalance.updateValue(calculatedBalanceForBottom, forKey: dataCondition.nameCurrencyForBottom!)
			
			if dataCondition.topTextField == nil {
				alertControlWithOutPrice()
			}
			
			alertControlWithPrice(debitedFromNameBalance: dataCondition.nameCurrencyForTop ?? "", howMuchDebited: calculatedCurrency, currentNameBalance: dataCondition.nameCurrencyForBottom ?? "", currentBalance: calculatedBalanceForBottom)
			
			topCollectionView.reloadData()
			bottomCollectionView.reloadData()
			
		}
		if dataCondition.topTextField == nil {
			let calculatedCurrency = dataCondition.calculateFromBottomText(bottomTextField: dataCondition.bottomTextField ?? 0, bottomCurrency: dataCondition.bottomCurrency ?? 0, topcurrency: dataCondition.topCurrency ?? 0)
			
			let valueOfListTopBalance = searchValueInListOfTopBalance()
			let valueOfListBottomBalance = searchValueOfListBottomBalance()
			
			let calculatedBalanceForTop = dataCondition.calculateTopBalance(currentTopBalance: valueOfListTopBalance, currentTextField: Double(calculatedCurrency) ?? 0)
			let calculatedBalanceForBottom = dataCondition.calculateBottomBalance(dataAfterCalculated: dataCondition.bottomTextField ?? 0, currentBottomBalance: valueOfListBottomBalance)
			
			listOfTopBalance.updateValue(calculatedBalanceForTop, forKey: dataCondition.nameCurrencyForTop!)
			listOfBottomBalance.updateValue(calculatedBalanceForBottom, forKey: dataCondition.nameCurrencyForBottom!)
			
			if dataCondition.bottomTextField == nil {
				alertControlWithOutPrice()
			}
			
			alertControlWithPrice(debitedFromNameBalance: dataCondition.nameCurrencyForBottom ?? "", howMuchDebited: calculatedCurrency, currentNameBalance: dataCondition.nameCurrencyForTop ?? "", currentBalance: calculatedBalanceForTop)
			
			bottomCollectionView.reloadData()
			topCollectionView.reloadData()
		}
		
	}
	
	func alertControlWithPrice (debitedFromNameBalance: String, howMuchDebited: String, currentNameBalance: String, currentBalance: Double) {
		let alert = "С баланса \(debitedFromNameBalance) списано: \(howMuchDebited), баланс \(currentNameBalance) стал: \(currentBalance)"
		let alertController = UIAlertController(title: "", message: alert, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { (actionv) in
			ViewController.completion!()
		}
		
		alertController.addAction(action)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func alertControlWithOutPrice () {
		let alert = "Для конвертации средств введите сумму, которую хотите перевести"
		let alertController = UIAlertController(title: "", message: alert, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { (actionv) in
			ViewController.completion!()
		}
		
		alertController.addAction(action)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func searchValueInListOfTopBalance () -> Double {
		var dataValue = 0.0
		for i in listOfTopBalance {
			if i.key == dataCondition.nameCurrencyForTop {
				dataValue = i.value
			}
		}
		return dataValue
	}
	
	func searchValueOfListBottomBalance () -> Double {
		var dataValue = 0.0
		for a in listOfBottomBalance {
			if a.key == dataCondition.nameCurrencyForBottom {
				dataValue = a.value
			}
		}
		return dataValue
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		topCollectionView.delegate = self
		bottomCollectionView.delegate = self
		
		topCollectionView.dataSource = self
		bottomCollectionView.dataSource = self
		
		reloadPaddingOfCollectionView()
		
		CurrencyService.fetchData() { newDictionary in
			self.dataOfCurrency = newDictionary
			DispatchQueue.main.async {
				self.topCollectionView.reloadData()
				self.bottomCollectionView.reloadData()
			}
		}
	}
	
	func reloadPaddingOfCollectionView () {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = topCollectionView.frame.size
		layout.itemSize = bottomCollectionView.frame.size
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 10
		
		topCollectionView.setCollectionViewLayout(layout, animated: false)
		topCollectionView.isPagingEnabled = true
		topCollectionView.alwaysBounceVertical = false
		
		bottomCollectionView.setCollectionViewLayout(layout, animated: false)
		bottomCollectionView.isPagingEnabled = true
		bottomCollectionView.alwaysBounceVertical = false
	}
	
	static var completionForTop: ((String) -> ())?
	static var completionForBottom: ((String) -> ())?
	static var completion: (() -> ())?
	
	
	@objc func duplicateTextForTopTextField (textField: UITextField) {
		if let text = textField.text {
			dataCondition.topTextField = Double(text)
			let text2 = dataCondition.calculateFromTopText(topTextField: dataCondition.topTextField ?? 0, topCurrency: dataCondition.topCurrency!, bottomCurrency: dataCondition.bottomCurrency!)

			ViewController.completionForTop!("+\(text2)")
		} else { return }
		
		if textField.text == "" {
			ViewController.completionForTop!(textField.text!)
		}
	}
	
	@objc func duplicateTextForBottomField (textField: UITextField) {
		if let text = textField.text {
			dataCondition.bottomTextField = Double(text)
			
			let text2 = dataCondition.calculateFromBottomText(bottomTextField: dataCondition.bottomTextField ?? 0, bottomCurrency: dataCondition.bottomCurrency!, topcurrency: dataCondition.topCurrency!)
			ViewController.completionForBottom!("+\(text2)")
		} else { return }
		
		if textField.text == "" {
			ViewController.completionForBottom!(textField.text!)
		}
	}
	
	
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataOfCurrency.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == topCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCollectionId", for: indexPath) as? TopCollectionViewCell
			
			cell?.topNameCurrency.text = String(dataOfCurrency[indexPath.row].key)
			cell?.topCurrectCurrency.text = String(dataOfCurrency[indexPath.row].value)
			
			let chooseBalance = dataOfCurrency[indexPath.row].key
			
			switch chooseBalance {
			case "USD": cell?.topBalance.text = String(listOfTopBalance["USD"]!)
			case "GBP": cell?.topBalance.text = String(listOfTopBalance["GBP"]!)
			case "EUR": cell?.topBalance.text = String(listOfTopBalance["EUR"]!)
			default: print("error")
			}
			
			switch cell?.topNameCurrency.text {
			case "USD": dataCondition.nameCurrencyForTop = cell?.topNameCurrency.text
			case "GBP": dataCondition.nameCurrencyForTop = cell?.topNameCurrency.text
			case "EUR": dataCondition.nameCurrencyForTop = cell?.topNameCurrency.text
			default: print("error")
			}
			
			if let convertCurrency = cell?.topCurrectCurrency.text {
				dataCondition.topCurrency = Double(convertCurrency)
			}
			if let convertBalance = cell?.topBalance.text {
				dataCondition.topBalance = Double(convertBalance)
			}
			
			cell?.topTextField?.addTarget(self, action: #selector(duplicateTextForTopTextField(textField:)), for: UIControl.Event.editingChanged)
			
			
			ViewController.completion = { [unowned self] in
				cell?.topTextField.text = ""
				self.duplicateTextForTopTextField(textField: cell!.topTextField)
			}
			
			return cell!
		}
		
		if collectionView == bottomCollectionView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCollectionId", for: indexPath) as? BottomCollectionViewCell
			
			cell?.bottomNameCurrency.text = String(dataOfCurrency[indexPath.row].key)
			cell?.bottomCurrectCurrency.text = String(dataOfCurrency[indexPath.row].value)
			
			let r = dataOfCurrency[indexPath.row].key
			
			switch r {
			case "USD": cell?.bottomBalance.text = String(listOfBottomBalance["USD"]!)
			case "GBP": cell?.bottomBalance.text = String(listOfBottomBalance["GBP"]!)
			case "EUR": cell?.bottomBalance.text = String(listOfBottomBalance["EUR"]!)
			default: print("error")
			}
			
			switch cell?.bottomNameCurrency.text {
			case "USD": dataCondition.nameCurrencyForBottom = cell?.bottomNameCurrency.text
			case "GBP": dataCondition.nameCurrencyForBottom = cell?.bottomNameCurrency.text
			case "EUR": dataCondition.nameCurrencyForBottom = cell?.bottomNameCurrency.text
			default: print("error")
			}
			
			if let convertCurrency = cell?.bottomCurrectCurrency.text {
				dataCondition.bottomCurrency = Double(convertCurrency)
			}
			if let convertBalance = cell?.bottomBalance.text {
				dataCondition.bottomBalance = Double(convertBalance)
			}
	
			cell?.bottomTextField.addTarget(self, action: #selector(duplicateTextForBottomField(textField:)), for: UIControl.Event.editingChanged)
			
			ViewController.completion = { [unowned self] in
				cell?.bottomTextField.text = ""
				self.duplicateTextForBottomField(textField: cell!.bottomTextField)
			}
			
			return cell!
			
		}
		
		return UICollectionViewCell()
	}
	
	
	
}

