//
//  ViewController.swift
//  BMI
//
//  Created by 최우영 on 2023/04/05.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    private var bmiManager = BMICalculatorManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabel()
        configureTextField()
        configureButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if heightTextField.text == "" || weightTextField.text == "" {
            mainLabel.text = "키와 몸무게를 입력하셔야만 합니다."
            mainLabel.textColor = .red
            return false
        }
        mainLabel.text = "키와 몸무게를 입력해 주세요."
        mainLabel.textColor = .black
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondViewController" {
            guard
                let secondViewController = segue.destination as? SecondViewController,
                let heightString = heightTextField.text,
                let weightString = weightTextField.text
            else {
                return
            }
            
            secondViewController.bmi = bmiManager.getBMI(height: heightString, weight: weightString)
        }
        
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    private func configureLabel() {
        mainLabel.text = "키와 몸무게를 입력해 주세요."
    }
    
    private func configureTextField() {
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        heightTextField.placeholder = "cm단위로 입력해 주세요."
        
        weightTextField.placeholder = "kg단위로 입력해 주세요."
    }
    
    private func configureButton() {
        calculateButton.clipsToBounds = true
        calculateButton.layer.cornerRadius = 5
        calculateButton.setTitle("BMI 계산하기", for: .normal)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Int(string) != nil || string == "" {
            // 글자 입력을 허용
            return true
        }
        
        // 글자 입력을 허용하지 않음
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if heightTextField.text != "", weightTextField.text != "" {
            weightTextField.resignFirstResponder()
            return true
        } else if heightTextField.text != "" {
            weightTextField.becomeFirstResponder()
            return true
        }
        return false
    }
}
