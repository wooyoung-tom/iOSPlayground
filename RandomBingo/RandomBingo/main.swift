//
//  main.swift
//  RandomBingo
//
//  Created by 최우영 on 2023/04/03.
//

import Foundation

var computerChoice = Int.random(in: 1...100)

var myChoice: Int = 0

while true {
    if let input = readLine() {
        if let number = Int(input) {
            myChoice = number
        }
    }

    if computerChoice > myChoice {
        print("Up")
    } else if computerChoice < myChoice {
        print("Down")
    } else {
        print("Bingo")
        break
    }
}
