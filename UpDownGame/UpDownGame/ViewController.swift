//
//  ViewController.swift
//  UpDownGame
//
//  Created by 최우영 on 2023/04/04.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var comRandomNumber = Int.random(in: 1...10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = "선택하세요"
        numberLabel.text = ""
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        // 1. 버튼의 숫자를 가져와야 함
        guard let numberString = sender.currentTitle else { return }
        
        // 2. 버튼을 누르면 numberLabel 값이 바뀌어야 함
        numberLabel.text = numberString
    }
    
    @IBAction func selectButtonPressed(_ sender: UIButton) {
        guard let number = Int(numberLabel.text ?? "") else { return }
        
        // 1. 컴퓨터의 숫자와 내가 선택한 숫자를 비교해서 up, down, bingo 표시
        if comRandomNumber > number {
            mainLabel.text = "Up"
        } else if comRandomNumber < number {
            mainLabel.text = "Down"
        } else {
            mainLabel.text = "Bingo👍"
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        // 1. mainLabel 초기화
        mainLabel.text = "선택하세요"
        
        // 2. 컴퓨터의 랜덤 숫자를 다시 선택
        comRandomNumber = Int.random(in: 1...10)
        
        // 3. numberLabel 초기화
        numberLabel.text = ""
    }
}

