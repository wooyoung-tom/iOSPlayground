//
//  BMI.swift
//  BMI
//
//  Created by 최우영 on 2023/04/06.
//

import UIKit

struct BMI {
    let value: Double
    let matchColor: UIColor
    let advice: String
    
    init() {
        self.value = 0.0
        self.matchColor = .white
        self.advice = "문제발생"
    }
    
    init(value: Double, matchColor: UIColor, advice: String) {
        self.value = value
        self.matchColor = matchColor
        self.advice = advice
    }
}
