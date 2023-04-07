//
//  SecondViewController.swift
//  BMI
//
//  Created by 최우영 on 2023/04/05.
//

import UIKit

final class SecondViewController: UIViewController {
    
    @IBOutlet weak var bmiNumberLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    var bmi: BMI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabel()
        configureButton()
        
        guard let bmi = bmi else { return }
        
        bmiNumberLabel.backgroundColor = bmi.matchColor
        bmiNumberLabel.text = String(bmi.value)
        adviceLabel.text = String(bmi.advice)
    }
    
    private func configureLabel() {
        bmiNumberLabel.clipsToBounds = true
        bmiNumberLabel.layer.cornerRadius = 8
    }
    
    private func configureButton() {
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 5
        backButton.setTitle("다시 계산하기", for: .normal)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
