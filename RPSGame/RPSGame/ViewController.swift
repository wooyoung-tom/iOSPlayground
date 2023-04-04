//
//  ViewController.swift
//  RPSGame
//
//  Created by 최우영 on 2023/04/03.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var comImageView: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    @IBOutlet weak var comChoiceLabel: UILabel!
    @IBOutlet weak var myChoiceLabel: UILabel!
    
    var comChoice: RPS = RPS(rawValue: Int.random(in: 0...2))!
    var myChoice: RPS = RPS.rock
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 준비 이미지를 띄워야 한다.
        comImageView.image = UIImage(named: "ready.png")
        myImageView.image = UIImage(named: "ready.png")
        
        // 2. 준비 레이블을 띄워야 한다.
        comChoiceLabel.text = "준비"
        myChoiceLabel.text = "준비"
    }

    @IBAction func rpsButtonTapped(_ sender: UIButton) {
        // 가위, 바위, 보 선택 후 해당 정보를 저장해야 한다.
        
        // 버튼 레이블이 있다는 것이 보장되기 때문에 지금은 괜찮음
        let title = sender.currentTitle!
        
        switch title {
        case "가위":
            myChoice = RPS.scissors
        case "바위":
            myChoice = RPS.rock
        case "보":
            myChoice = RPS.paper
        default:
            break
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        switch comChoice {
        case RPS.rock:
            comImageView.image = UIImage(named: "rock.png")
            comChoiceLabel.text = "바위"
        case RPS.paper:
            comImageView.image = UIImage(named: "paper.png")
            comChoiceLabel.text = "보"
        case RPS.scissors:
            comImageView.image = UIImage(named: "scissors.png")
            comChoiceLabel.text = "가위"
        }
        
        switch myChoice {
        case RPS.rock:
            myImageView.image = UIImage(named: "rock.png")
            myChoiceLabel.text = "바위"
        case RPS.paper:
            myImageView.image = UIImage(named: "paper.png")
            myChoiceLabel.text = "보"
        case RPS.scissors:
            myImageView.image = UIImage(named: "scissors.png")
            myChoiceLabel.text = "가위"
        }
        
        if comChoice == myChoice {
            mainLabel.text = "비겼다"
        } else if comChoice == .rock && myChoice == .paper {
            mainLabel.text = "이겼다"
        } else if comChoice == .paper && myChoice == .scissors {
            mainLabel.text = "이겼다"
        } else if comChoice == .scissors && myChoice == .rock {
            mainLabel.text = "이겼다"
        } else {
            mainLabel.text = "졌다"
        }
    }
   
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        comImageView.image = UIImage(named: "ready.png")
        comChoiceLabel.text = "준비"
        
        myImageView.image = UIImage(named: "ready.png")
        myChoiceLabel.text = "준비"
        
        mainLabel.text = "선택하세요"
        
        comChoice = RPS(rawValue: Int.random(in: 0...2))!
    }
}
