//
//  DataCondition.swift
//  NewCurrencyProject
//
//  Created by Dmitry Kutlyev on 23/06/2019.
//  Copyright © 2019 Dmitry Kutlyev. All rights reserved.
//

import Foundation

class DataCondition {
	
	var topTextField: Double?
	var bottomTextField: Double?
	
	var topCurrency: Double?
	var bottomCurrency: Double?
	
	var topBalance: Double?
	var bottomBalance:Double?
	
	var nameCurrencyForTop: String?
	var nameCurrencyForBottom: String?
	
	
	func calculateFromTopText (topTextField: Double, topCurrency: Double, bottomCurrency: Double) -> String {
		let data = (topTextField / topCurrency) * bottomCurrency
		let data2 = String(format: "%.2f", data)
		return data2
	}
	
	func calculateFromBottomText (bottomTextField: Double, bottomCurrency: Double, topcurrency: Double) -> String {
		let data = (bottomTextField / bottomCurrency) * topcurrency
		let data2 = String(format: "%.2f", data)
		return data2
	}
	
	func calculateTopBalance (currentTopBalance: Double, currentTextField: Double) -> Double {
		let calculatedData = currentTopBalance - currentTextField
		return calculatedData
	}
	
	func calculateBottomBalance (dataAfterCalculated: Double, currentBottomBalance: Double) -> Double {
		let calculatedData = dataAfterCalculated + currentBottomBalance
		return calculatedData
	}
	
}
