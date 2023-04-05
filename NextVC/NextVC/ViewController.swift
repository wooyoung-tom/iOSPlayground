//
//  ViewController.swift
//  NextVC
//
//  Created by Allen H on 2021/12/05.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThirdViewController" {
            guard let thirdViewController = segue.destination as? ThirdViewController else { return }
            thirdViewController.someString = "Some String 3"
        }
        
        if segue.identifier == "toFourthViewController" {
            guard let fourthViewController = segue.destination as? FourthViewController else { return }
            fourthViewController.someString = "Some String 4"
        }
    }
    
    // 직접적인 세그웨이를 만들었을 때만 호출된다. (ex. 버튼에서 직접 연결을 하는 등)
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let num = 7
        return num < 3
    }
    
    // 1) 코드로 화면 이동 (다음화면이 코드로 작성되어있을때만 가능한 방법)
    @IBAction func codeNextButtonTapped(_ sender: UIButton) {
        let firstViewContoller = FirstViewController()
        
        firstViewContoller.someString = "Some String"
        
        firstViewContoller.modalPresentationStyle = .fullScreen
        present(firstViewContoller, animated: true)
    }
    
    // 2) 코드로 스토리보드 객체를 생성해서, 화면 이동
    @IBAction func storyboardWithCodeButtonTapped(_ sender: UIButton) {
        // view controller에 storyboard property가 존재함.
        let secondViewControllerInstance = storyboard?.instantiateViewController(withIdentifier: "SecondViewController")
        
        if let secondViewController = secondViewControllerInstance as? SecondViewController {
            secondViewController.someString = "Some String 2"
            present(secondViewController, animated: true)
        }
    }
    
    // 3) 스토리보드에서의 화면 이동(간접 세그웨이)
    @IBAction func storyboardWithSegueButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toThirdViewController", sender: self)
    }
}
