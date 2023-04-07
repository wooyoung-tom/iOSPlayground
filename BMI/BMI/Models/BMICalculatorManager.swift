//
//  BMICalculatorManager.swift
//  BMI
//
//  Created by 최우영 on 2023/04/06.
//

import UIKit

struct BMICalculatorManager {
    
    private var bmi = BMI()
    
    mutating func getBMI(height: String, weight: String) -> BMI {
        // call BMI calculate method
        calculateBMI(height: height, weight: weight)
        
        // return result
        return bmi
    }
    
    mutating private func calculateBMI(height: String, weight: String) {
        guard
            let h = Double(height),
            let w = Double(weight)
        else {
            bmi = BMI()
            return
        }
        
        var bmiNumber = w / (h * h) * 10000
        bmiNumber = round(bmiNumber * 10) / 10
        
        switch bmiNumber {
        case ..<18.6:
            bmi = BMI(value: bmiNumber, matchColor: UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1), advice: "저체중")
        case 18.6..<23.0:
            bmi = BMI(value: bmiNumber, matchColor: UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1), advice: "표준")
        case 23.0..<25.0:
            bmi = BMI(value: bmiNumber, matchColor: UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1), advice: "과체중")
        case 25.0..<30.0:
            bmi = BMI(value: bmiNumber, matchColor: UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1), advice: "중도비만")
        case 30.0...:
            bmi = BMI(value: bmiNumber, matchColor: UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1), advice: "고도비만")
        default:
            bmi = BMI(value: bmiNumber, matchColor: .black, advice: "")
        }
    }
}
