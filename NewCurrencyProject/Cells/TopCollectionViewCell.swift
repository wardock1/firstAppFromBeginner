//
//  TopCollectionViewCell.swift
//  NewCurrencyProject
//
//  Created by Dmitry Kutlyev on 23/06/2019.
//  Copyright © 2019 Dmitry Kutlyev. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
	
	@IBOutlet weak var topNameCurrency: UILabel!
	@IBOutlet weak var topBalance: UILabel!
	@IBOutlet weak var topCurrectCurrency: UILabel!
	@IBOutlet weak var topTextField: UITextField! {
		didSet {
			changingTextForTop()
			topTextField.delegate = self
		}
	}
	
	func changingTextForTop () {
		ViewController.completionForBottom = { [unowned self] text in
			print("dannie top here")
			self.topTextField.text = text
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let allowedCharaters = "1234567890"
		let allowedCharaterSet = CharacterSet(charactersIn: allowedCharaters)
		let typeCharaterSet = CharacterSet(charactersIn: string)
		return allowedCharaterSet.isSuperset(of: typeCharaterSet)
	}
	
}
