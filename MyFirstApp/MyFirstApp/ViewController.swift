//
//  ViewController.swift
//  MyFirstApp
//
//  Created by 최우영 on 2023/04/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        mainLabel.text = "안녕하세요"
        mainLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
}
