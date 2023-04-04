//
//  ViewController.swift
//  FirstNewApp
//
//  Created by 최우영 on 2023/04/04.
//

import UIKit

import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    private weak var timer: Timer?
    
    private var number: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    func configureUI() {
        mainLabel.text = "초를 선택하세요"
        slider.value = 0.5
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        // number variable init
        number = Int(sender.value * 60)
        mainLabel.text = "\(number)초"
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(doSomethingAfter1Second),
            userInfo: nil,
            repeats: true
        )
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // 초기화 세팅
        mainLabel.text = "초를 선택하세요"
        
        // 슬라이더의 가운데로 초기화
        slider.setValue(0.5, animated: true)
        
        // number 변수 초기화
        number = 0
        
        // 타이머 무효화
        timer?.invalidate()
    }
    
    @objc func doSomethingAfter1Second() {
        if number > 0 {
            number -= 1
            
            slider.value = Float(number) / Float(60)
            
            mainLabel.text = "\(number)초"
        } else {
            number = 0
            
            mainLabel.text = "초를 선택하세요."
            
            // 타이머 설정 비활성화
            timer?.invalidate()
            
            // 소리를 나게 해야 함
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
    }
}
