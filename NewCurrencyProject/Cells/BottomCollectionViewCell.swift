//
//  BottomCollectionViewCell.swift
//  NewCurrencyProject
//
//  Created by Dmitry Kutlyev on 23/06/2019.
//  Copyright © 2019 Dmitry Kutlyev. All rights reserved.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
	
	@IBOutlet weak var bottomNameCurrency: UILabel!
	@IBOutlet weak var bottomBalance: UILabel!
	@IBOutlet weak var bottomCurrectCurrency: UILabel!
	@IBOutlet weak var bottomTextField: UITextField! {
		didSet {
			changingTextForBottom()
			bottomTextField.delegate = self
		}
	}
	
	func changingTextForBottom () {
		ViewController.completionForTop = { [unowned self] text in
			print("dannie bot here")
			self.bottomTextField.text = text
			
		}
//		ViewController.testcompletion = { [unowned self]  in
//			self.bottomTextField.text = ""
//			print("ZASHLo")
//		}
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let allowedCharaters = "1234567890"
		let allowedCharaterSet = CharacterSet(charactersIn: allowedCharaters)
		let typeCharaterSet = CharacterSet(charactersIn: string)
		return allowedCharaterSet.isSuperset(of: typeCharaterSet)
	}
	
}
